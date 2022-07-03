/* checksum : 7cda4467c28336c28e04f8028bd27bd3 */
@cds.external : true
service APIContent {};

@cds.persistence.skip : true
@m.HasStream : 'true'
entity APIContent.APIs {
  key Name : String(100);
  ID : String(100);
  Title : String(256);
  ShortText : String(1000);
  Version : String(10);
  ServiceCode : String(10);
  ServiceUrl : LargeString;
  Deprecated : Boolean;
  hasManagedContent : Boolean;
  @odata.type : 'Edm.DateTime'
  @odata.precision : 0
  CreatedAt : DateTime;
  CreatedBy : String(256);
  @odata.type : 'Edm.DateTime'
  @odata.precision : 0
  ModifiedAt : DateTime;
  ModifiedBy : String(256);
  ParentTechnicalName : LargeString;
  State : String(20);
  ChangeLog : LargeString;
  ExternalDocs : LargeString;
  ReleaseInfo : LargeString;
  MultiVersion : Boolean;
  @cds.ambiguous : 'missing on condition?'
  Versions : Association to many APIContent.APIs {  };
};

@cds.persistence.skip : true
@m.HasStream : 'true'
entity APIContent.PolicyTemplates {
  key Name : String(255);
  Title : String(256);
  ID : String(100);
  ShortText : String(1000);
  Version : String(10);
  @odata.type : 'Edm.DateTime'
  @odata.precision : 0
  CreatedAt : DateTime;
  CreatedBy : String(256);
  @odata.type : 'Edm.DateTime'
  @odata.precision : 0
  ModifiedAt : DateTime;
  ModifiedBy : String(256);
};

