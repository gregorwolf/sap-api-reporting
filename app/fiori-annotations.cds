using {api} from '../db/schema';

annotate api.APIs with @(UI : {
  SelectionFields                  : [
    ServiceCode,
    Version,
    Deprecated,
    ParentTechnicalName,
    State,
  ],
  PresentationVariant #ServiceCode : {Visualizations : ['@UI.Chart#ServiceCode', ], },
  /*
  PresentationVariant #Version             : {Visualizations : ['@UI.Chart#Version', ], },
  PresentationVariant #Deprecated          : {Visualizations : ['@UI.Chart#Deprecated', ], },
  PresentationVariant #ParentTechnicalName : {Visualizations : ['@UI.Chart#ParentTechnicalName', ], },
  PresentationVariant #State               : {Visualizations : ['@UI.Chart#State', ], },
  */
  Chart #ServiceCode               : {
    ChartType           : #Column,
    Dimensions          : [ServiceCode],
    DimensionAttributes : [{
      Dimension : ServiceCode,
      Role      : #Category
    }],
    Measures            : [numberOfAPIs],
    MeasureAttributes   : [{
      Measure : numberOfAPIs,
      Role    : #Axis1
    }]
  },
  LineItem                         : [
    {Value : Name},
    {Value : Title},
    {Value : Version},
    {Value : State},
  ],

}) {
  @(ValueList.entity : 'ServiceCodeVH', )
  ServiceCode;
  @(ValueList.entity : 'VersionVH', )
  Version;
  @(ValueList.entity : 'DeprecatedVH', )
  Deprecated;
  @(ValueList.entity : 'ParentTechnicalNameVH', )
  ParentTechnicalName;
  @(ValueList.entity : 'StateVH', )
  State;
};
