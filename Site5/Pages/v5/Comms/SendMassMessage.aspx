﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Master-v5.master" AutoEventWireup="true" CodeFile="SendMassMessage.aspx.cs" Inherits="Swarmops.Frontend.Pages.Comms.SendMassMessage" %>
<%@ Register src="~/Controls/v5/UI/ExternalScripts.ascx" tagname="ExternalScripts" tagprefix="Swarmops5" %>
<%@ Register src="~/Controls/v5/Base/ComboGeographies.ascx" tagname="ComboGeographies" tagprefix="Swarmops5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PlaceHolderHead" Runat="Server">
    <Swarmops5:ExternalScripts ID="ExternalScripts2" Package="easyui" Control="tree" runat="server" />
	<link rel="stylesheet" type="text/css" href="/Style/v5-easyui-elements.css">
    
    <script type="text/javascript">

        $(document).ready(function () {
            // Document.Ready() goes here

            $('#<%=this.DropRecipientClasses.ClientID%>').change (function() {
                onGeographyChange(selectedGeographyId); // does the same thing anyway
            })
        });

        var selectedReceipientClass = 1;
        var selectedGeographyId = 1;  // TODO: SET ROOT GEOGRAPHY BY AUTHORITY/ACCESS

        function onGeographyChange(newGeographyId) {
            $.ajax({
                type: "POST",
                url: "SendMassMessage.aspx/GetRecipientCount",
                data: "{'recipientTypeId': '" + $('#<%=this.DropRecipientClasses.ClientID %>').val() + "', 'geographyId':'" + newGeographyId + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    $('#spanRecipientCount').text(msg.d);
                }
            });
            selectedGeographyId = newGeographyId;
        }

        function onClickSend() {
            alertify.alert("<%= Resources.Pages.Comms.SendMassMessage_SendMessageResult %>");
            return false;
        }

        function onClickTest() {
            alertify.alert("<%= Resources.Pages.Comms.SendMassMessage_TestMessageResult %>");
            return false;
        }

    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PlaceHolderMain" Runat="Server">
    <div class="entryFields" style="padding-top:4px">
        <asp:DropDownList runat="server" ID="DropRecipientClasses"/><br/>
        <Swarmops5:ComboGeographies ID="ComboGeographies" runat="server" OnClientSelect="onGeographyChange" />&thinsp;<br/>
    </div>
    <div class="entryLabels" style="padding-top:10px">
        <asp:Label ID="LabelRecipientType" runat="server" /><br/>
        <asp:Label ID="LabelGeography" runat="server" /><br/>
    </div>
    <h2 style="padding-top:15px"><asp:Label ID="LabelHeaderMessage" runat="server" /> (<span id="spanRecipientCount">0</span>)</h2>
    <asp:TextBox runat="server" TextMode="MultiLine" Rows="10" ID="TextMessage" Text="This page is a mockup for now; it doesn't actually send anything. What you want to try is to send to the [Regulars] recipients and see how the recipient count changes with choice of geography." />
    <asp:Button runat="server" CssClass="buttonAccentColor" Text="Foo" OnClientClick="onClickSend(); return false;" ID="ButtonSend" /><asp:Button runat="server" CssClass="buttonAccentColor" OnClientClick="onClickTest(); return false;" Text="Bar" ID="ButtonTest" />
    <div style="clear:both"></div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PlaceHolderSide" Runat="Server">
</asp:Content>

