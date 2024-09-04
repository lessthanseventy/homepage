defmodule Lessthanseventy.XMLTest do
  use Lessthanseventy.DataCase

  alias Lessthanseventy.XML

  @xml_content """
  <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
  <document xmlns="http://www.abbyy.com/FineReader_xml/FineReader10-schema-v1.xml" version="1.0" producer="" languages="" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.abbyy.com/FineReader_xml/FineReader10-schema-v1.xml http://www.abbyy.com/FineReader_xml/FineReader10-schema-v1.xml">
  <page width="2555" height="3532" resolution="300" originalCoords="1">
  <block blockType="Text" l="184" t="156" r="249" b="3105"><region><rect l="184" t="156" r="246" b="591"/><rect l="184" t="591" r="247" b="600"/><rect l="185" t="600" r="247" b="1761"/><rect l="185" t="1761" r="248" b="1771"/><rect l="186" t="1771" r="248" b="2932"/><rect l="186" t="2932" r="249" b="2941"/><rect l="187" t="2941" r="249" b="3105"/></region>
  <text>
  <par leftIndent="900" lineSpacing="1330">
  <line baseline="1220" l="920" t="1180" r="1784" b="1221"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12." bold="1">SUPERIOR COURT OF CALIFORNIA</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="746" t="1284" r="1960" b="1343"><region><rect l="1858" t="1284" r="1960" b="1285"/><rect l="746" t="1285" r="1960" b="1342"/><rect l="746" t="1342" r="1867" b="1343"/></region>
  <text>
  <par lineSpacing="1330">
  <line baseline="1331" l="761" t="1293" r="1943" b="1338"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12." bold="1">COUNTY OF LOS ANGELES, CENTRAL DISTRICT</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="290" t="1391" r="1050" b="1566"><region><rect l="688" t="1391" r="1050" b="1392"/><rect l="290" t="1392" r="1050" b="1456"/><rect l="326" t="1456" r="1050" b="1565"/><rect l="326" t="1565" r="697" b="1566"/></region>
  <text>
  <par leftIndent="7800" startIndent="-7800" lineSpacing="2664">
  <line baseline="1442" l="302" t="1403" r="1044" b="1451"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12.">ANGELO ANGELES, an individual,</formatting></line>
  <line baseline="1554" l="616" t="1515" r="787" b="1562"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12.">Plaintiff,</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="1286" t="1393" r="1574" b="1511"><region><rect l="1286" t="1393" r="1574" b="1511"/></region>
  <text>
  <par lineSpacing="1608">
  <line baseline="1440" l="1302" t="1402" r="1558" b="1449"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12.">) Case No.:</formatting></line></par>
  <par lineSpacing="1608">
  <line baseline="1507" l="1302" t="1459" r="1316" b="1506"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="11." bold="1">)</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="1770" t="1374" r="2214" b="1473"><region><rect l="1858" t="1374" r="2214" b="1375"/><rect l="1770" t="1375" r="2214" b="1472"/><rect l="1771" t="1472" r="1867" b="1473"/></region>
  <text>
  <par align="Justified">
  <line baseline="1460" l="1787" t="1393" r="2199" b="1470"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="21." bold="1" scaling="700">B C </formatting><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="21." bold="1" superscript="1" scaling="700">6</formatting><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="21." bold="1" scaling="700"> 4 8 7 4 4</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="1286" t="1511" r="1810" b="1621"><region><rect l="1286" t="1511" r="1810" b="1567"/><rect l="1286" t="1567" r="1344" b="1621"/></region>
  <text>
  <par lineSpacing="1330">
  <line baseline="1552" l="1302" t="1515" r="1805" b="1561"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12." bold="1">) COMPLAINT FOR:</formatting></line></par>
  <par lineSpacing="1110">
  <line baseline="1618" l="1303" t="1570" r="1316" b="1617"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="10." bold="1">)</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="432" t="1634" r="516" b="1670"><region><rect l="432" t="1634" r="516" b="1669"/><rect l="433" t="1669" r="516" b="1670"/></region>
  <text>
  <par lineSpacing="1330">
  <line baseline="1665" l="448" t="1640" r="500" b="1665"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12.">vs.</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="290" t="1623" r="1333" b="1899"><region><rect l="941" t="1623" r="1332" b="1624"/><rect l="940" t="1624" r="1332" b="1735"/><rect l="688" t="1735" r="1332" b="1736"/><rect l="290" t="1736" r="1332" b="1761"/><rect l="290" t="1761" r="1333" b="1771"/><rect l="291" t="1771" r="1333" b="1845"/><rect l="291" t="1845" r="1333" b="1846"/><rect l="941" t="1846" r="1333" b="1899"/></region>
  <text>
  <par align="Justified" leftIndent="24300" lineSpacing="1320">
  <line baseline="1673" l="1302" t="1626" r="1316" b="1672"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="11." bold="1">)</formatting></line>
  <line baseline="1728" l="1303" t="1681" r="1316" b="1727"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="10." bold="1">)</formatting></line></par>
  <par align="Justified" lineSpacing="1320">
  <line baseline="1775" l="301" t="1735" r="1317" b="1784"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12.">HILL-ROM COMPANY, INC., an Indiana )</formatting></line>
  <line baseline="1830" l="303" t="1792" r="1316" b="1841"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12.">corporation; and DOES 1 through 100, inclusive, )</formatting></line></par>
  <par align="Justified" leftIndent="24300" lineSpacing="1110">
  <line baseline="1895" l="1303" t="1847" r="1316" b="1894"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="10." bold="1">)</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="1418" t="1619" r="1474" b="1665"><region><rect l="1418" t="1619" r="1474" b="1665"/></region>
  <text>
  <par lineSpacing="1330">
  <line baseline="1662" l="1433" t="1626" r="1461" b="1661"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12.">1.</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="1413" t="1839" r="1477" b="1887"><region><rect l="1413" t="1839" r="1477" b="1887"/></region>
  <text>
  <par lineSpacing="1330">
  <line baseline="1884" l="1429" t="1847" r="1461" b="1883"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12." bold="1">2</formatting><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="6." bold="1">.</formatting></line></par>
  </text>
  </block>
  <block blockType="Text" l="601" t="1895" r="867" b="1946"><region><rect l="688" t="1895" r="866" b="1896"/><rect l="601" t="1896" r="867" b="1945"/><rect l="601" t="1945" r="697" b="1946"/></region>
  <text>
  <par lineSpacing="1330">
  <line baseline="1941" l="616" t="1903" r="851" b="1941"><formatting lang="EnglishUnitedStates" ff="Times New Roman" fs="12.">Defendants.</formatting></line></par>
  </document>
  """

  describe "xml_uploads" do
    alias Lessthanseventy.XML.XMLUpload

    import Lessthanseventy.XMLFixtures

    @invalid_attrs %{content: nil}

    @valid_attrs %{
      content: "some content",
      plaintiff: "some plaintiff",
      defendants: "some defendants"
    }
    @invalid_attrs %{}

    test "list_xml_uploads/0 returns all xml_uploads" do
      xml_upload = xml_upload_fixture()
      assert XML.list_xml_uploads() == [xml_upload]
    end

    test "get_xml_upload!/1 returns the xml_upload with given id" do
      xml_upload = xml_upload_fixture()
      assert XML.get_xml_upload!(xml_upload.id) == xml_upload
    end

    test "create_xml_upload/1 with valid data creates a xml_upload" do
      assert {:ok, %XMLUpload{} = xml_upload} = XML.create_xml_upload(@valid_attrs)
      assert xml_upload.content == "some content"
      assert xml_upload.plaintiff == "some plaintiff"
      assert xml_upload.defendants == "some defendants"
    end

    test "create_xml_upload/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = XML.create_xml_upload(@invalid_attrs)
    end

    test "delete_xml_upload/1 deletes the xml_upload" do
      xml_upload = xml_upload_fixture()
      assert {:ok, %XMLUpload{}} = XML.delete_xml_upload(xml_upload)
      assert_raise Ecto.NoResultsError, fn -> XML.get_xml_upload!(xml_upload.id) end
    end

    test "change_xml_upload/1 returns a xml_upload changeset" do
      xml_upload = xml_upload_fixture()
      assert %Ecto.Changeset{} = XML.change_xml_upload(xml_upload)
    end

    test "parse returns plaintiff, defendant tuple" do
      assert {"ANGELO ANGELES, an individual",
              "HILL-ROM COMPANY, INC., an Indiana  corporation; and DOES 1 through 100, inclusive,   1. 2 ."} =
               XML.parse(@xml_content)
    end
  end
end
