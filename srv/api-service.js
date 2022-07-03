const cds = require("@sap/cds");
const rootPath = "/odata/1.0/catalog.svc/";
const { format } = require("date-fns");

function cleanObject(obj) {
  Object.keys(obj).forEach((key) => {
    const value = obj[key];
    if (typeof value === "object") {
      delete obj[key];
    } else if (typeof value === "string") {
      // match the common sap odata date format like "/Date(1603065600000)/"
      // also matches the more uncommon "/Date(253402300799000+0000)/". But this will only work correctly for utc! (+0000)
      const matchDate = value.match(/\/Date\((-*\d+)\+*\d+\)\//);
      if (matchDate) {
        delete obj[key];
      }
      // match the sap odata time format like "PT09H50M58S"
      const matchTime = value.match(/^PT(\d\d)H(\d\d)M(\d\d)S/);
      if (matchTime) {
        delete obj[key];
      }
    }
  });
}

async function getAPIsCountFromService() {
  const directservice = await cds.connect.to("DIRECT");
  const apiContentPath =
    rootPath + `APIContent.APIs?$top=1&$skip=0&&$inlinecount=allpages`;
  const serviceAPIs = await directservice.send("GET", apiContentPath);
  //return 10;
  return parseInt(serviceAPIs.d.__count);
}

async function getAPIsFromService(limit) {
  const directservice = await cds.connect.to("DIRECT");
  const apiContentPath =
    rootPath +
    `APIContent.APIs?$top=${limit.rows}&$skip=${limit.offset}` +
    "&$select=Name,ID,Title,ShortText,Version,ServiceCode,ServiceUrl,Deprecated,hasManagedContent,CreatedBy,ModifiedBy,ParentTechnicalName,State,ChangeLog,ExternalDocs,ReleaseInfo,MultiVersion";
  const serviceAPIs = await directservice.send("GET", apiContentPath);
  /*
  const serviceAPIs = await APIContent.run(
    SELECT.from`APIContent.APIs`.limit(limit.rows, limit.offset)
  );
  */
  serviceAPIs.d.results.forEach(cleanObject);
  return serviceAPIs.d.results;
}

async function upsertAPI(serviceAPI) {
  const api = serviceAPI.Name;
  const db = await cds.connect.to("db");
  const { APIs } = db.entities;
  const dbAPIs = await db.run(
    SELECT.one(APIs).where({
      Name: api,
    })
  );
  if (dbAPIs === null) {
    console.log("Create API ", api);
    await db.run(INSERT.into(APIs).entries([serviceAPI]));
  } else {
    console.log("Update API ", api);
    await db.run(
      UPDATE(APIs, {
        Name: api,
      }).with(serviceAPI)
    );
  }
}

module.exports = cds.service.impl(async function () {
  const db = await cds.connect.to("db");
  const { APIs } = db.entities;

  this.on("loadAPIs", async function (req) {
    const blockSize = req.data.BlockSize;
    console.log("loadAPIs - blockSize:", blockSize);
    const count = await getAPIsCountFromService();
    console.log("count:", count);
    for (let top = 0; top < count; top = top + blockSize) {
      const limit = {
        offset: top,
        rows: blockSize,
      };
      const serviceAPIs = await getAPIsFromService(limit);
      console.log("Number of APIs:", serviceAPIs.length);
      for (let index = 0; index < serviceAPIs.length; index++) {
        const serviceAPI = serviceAPIs[index];
        await upsertAPI(serviceAPI);
      }
    }
  });
  this.on("deleteAllAPIs", async function (req) {
    await db.run(DELETE.from(APIs));
  });
});
