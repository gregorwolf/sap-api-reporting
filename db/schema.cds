using {APIContent} from '../srv/external/APIContent';

namespace api;

@cds.persistence.skip                            : false
// analytical annotation
@Aggregation.ApplySupported.PropertyRestrictions : true
// With this annotation the Fiori Application Generator also works
// with the CAP Project and shows the entity in the drop-down
@Aggregation.ApplySupported.Transformations      : true
entity APIs : APIContent.APIs {
    // add aditional field that is always filled with 1 to calculate the
    // number of messages in aggregations. This is our analytic measure
    @Analytics.Measure   : true
    @Aggregation.default : #SUM
    numberOfAPIs : Integer default 1 @(title : '{i18n>numberOfAPIs}');
};

view ServiceCodeView as select distinct ServiceCode from APIs;

@cds.odata.valuelist
entity ServiceCodeVH         as projection on ServiceCodeView {
    key ServiceCode
};

view VersionView as select distinct Version from APIs;

@cds.odata.valuelist
entity VersionVH             as projection on VersionView {
    key Version
};

view DeprecatedView as select distinct Deprecated from APIs;

@cds.odata.valuelist
entity DeprecatedVH          as projection on DeprecatedView {
    key Deprecated
};

view ParentTechnicalNameView as select distinct ParentTechnicalName from APIs;

@cds.odata.valuelist
entity ParentTechnicalNameVH as projection on ParentTechnicalNameView {
    key ParentTechnicalName
};

view StateView as select distinct State from APIs;

@cds.odata.valuelist
entity StateVH               as projection on StateView {
    key State
};
