<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.1.0"
 xmlns="http://www.opengis.net/sld"
 xmlns:ogc="http://www.opengis.net/ogc"
 xmlns:se="http://www.opengis.net/se"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.1.0/StyledLayerDescriptor.xsd"
>
  <NamedLayer>
    <se:Name>Points</se:Name>
    <UserStyle>
      <se:Name>Points</se:Name>
      <se:FeatureTypeStyle>
        <se:Rule>
          <se:Name>Single symbol</se:Name>
          <se:PointSymbolizer>
            <se:Graphic>
              <se:Mark>
                <se:WellKnownName>hexagon</se:WellKnownName>
                <se:Fill>
                  <se:SvgParameter name="fill">#f4970f</se:SvgParameter>
                </se:Fill>
                <se:Stroke>
                  <se:SvgParameter name="stroke">#8f8f8f</se:SvgParameter>
                  <se:SvgParameter name="stroke-width">2</se:SvgParameter>
                </se:Stroke>
              </se:Mark>
              <se:Size>13</se:Size>
            </se:Graphic>
          </se:PointSymbolizer>
        </se:Rule>
      </se:FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
