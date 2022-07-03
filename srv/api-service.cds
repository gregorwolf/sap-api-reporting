using {api} from '../db/schema';


service ApiService {

    @cds.redirection.target
    entity APIs                  as projection on api.APIs;

    entity ServiceCodeVH         as projection on api.ServiceCodeVH;
    entity VersionVH             as projection on api.VersionVH;
    entity DeprecatedVH          as projection on api.DeprecatedVH;
    entity ParentTechnicalNameVH as projection on api.ParentTechnicalNameVH;
    entity StateVH               as projection on api.StateVH;
    // Actions
    action loadAPIs(BlockSize : Integer);
    action deleteAllAPIs();

}
