﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Pages_v5_Init_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <!-- jQuery and plugins -->
    <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js" ></script>
    <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"></script>
    <script language="javascript" type="text/javascript" src="/Scripts/jquery.leanModal.min.js" ></script>
    <script language="javascript" type="text/javascript" src="/Scripts/jquery.smartWizard-2.0.min.js"></script>

    <!-- fonts -->
    <link href='https://fonts.googleapis.com/css?family=Permanent+Marker' rel='stylesheet' type='text/css' />
    <link href='https://fonts.googleapis.com/css?family=Ubuntu:light,regular,500,bold' rel='stylesheet' type='text/css' />
    <link href='https://fonts.googleapis.com/css?family=Arimo:regular,italic,bold,bolditalic' rel='stylesheet' type='text/css' />

    <!-- page title -->
	<title>Swarmops - Initialize Installation</title>

    <link href="/Style/style-v5.css" rel="stylesheet" type="text/css" />
    <link href="WizardStyle.css" rel="stylesheet" type="text/css" />

    <!-- initialize all modal popups -->
    <script language="javascript" type="text/javascript">
        $(function () {
            $("a[rel*=leanModal]").leanModal();
        });
    </script>
    
    <!-- hide "previous" button -->
    
    <style type="text/css">
	    .swMain .buttonPrevious 
        {
	         display: none;
	    }
        .PermissionsErrorCredentials 
        {
             font-weight: bold;
        }
        .PermissionsErrorResults 
        {
            font-size: 200%;
            text-align: center;
        }
    </style>

</head>
<body>
    <form id="form2" runat="server">
        <asp:ScriptManager runat="server" ID="ScriptManagerBlahblah" />
	    <script type="text/javascript">

	    var databaseInitComplete = false;

	    $(document).ready(function () {

	        $('#<%=this.TextCredentialsReadDatabase.ClientID %>').focusout(function () {
	            var dbValue = $('#<%=this.TextCredentialsReadDatabase.ClientID %>').val();
	            $('#<%=this.TextCredentialsWriteDatabase.ClientID %>').val(dbValue);
	            $('#<%=this.TextCredentialsAdminDatabase.ClientID %>').val(dbValue);
	        });

	        $('#<%=this.TextCredentialsReadServer.ClientID %>').focusout(function () {
	            var serverValue = $('#<%=this.TextCredentialsReadServer.ClientID %>').val();
	            $('#<%=this.TextCredentialsWriteServer.ClientID %>').val(serverValue);
	            $('#<%=this.TextCredentialsAdminServer.ClientID %>').val(serverValue);
	        });

	        // Initialize Smart Wizard	
	        $('#wizard').smartWizard({
	            transitionEffect: 'fade',
	            keyNavigation: false,
	            onLeaveStep: leaveAStepCallback,
	            onFinish: onFinishCallback
	        });

	        function leaveAStepCallback(obj) {
	            if (disableNext) {
	                return false;
	            }

	            var stepNum = obj.attr('rel');
	            return validateStep(stepNum);
	        }

	        function onFinishCallback(obj) {
	            $('#<%=this.ButtonLogin.ClientID %>').click();
	        }

	        function validateStep(stepNumber) {
	            var isValid = false;
	            var textBoxes;
	            var loop;
	            var fieldContents;
	            var hostName = $('#<%=this.TextServerName.ClientID %>').val();
	            var hostAddress = $('#<%=this.TextServerAddress.ClientID %>').val();

	            if (stepNumber == 1) {
	                // Validate Hostname, Host Address

	                if (hostName && hostName.length > 0 && hostAddress && hostAddress.length > 0) {
	                    $.ajax({
	                        type: "POST",
	                        url: "Default.aspx/VerifyHostNameAndAddress",
	                        data: "{'name': '" + escape(hostName) + "', 'address': '" + escape(hostAddress) + "'}",
	                        contentType: "application/json; charset=utf-8",
	                        dataType: "json",
	                        async: false,  // blocks until function returns - race conditions otherwise
	                        success: function (msg) {
	                            if (msg.d == true) {
	                                isValid = true;
	                            }
	                        }
	                    });
	                }


	                if (!isValid) {
	                    $('#<%=this.TextServerName.ClientID %>').css('background-image', "url('/Images/Icons/iconshock-cross-12px.png')").css('background-position', 'right center').css('background-repeat', 'no-repeat');
	                    $('#<%=this.TextServerAddress.ClientID %>').css('background-image', "url('/Images/Icons/iconshock-cross-12px.png')").css('background-position', 'right center').css('background-repeat', 'no-repeat');
	                } else {
	                    $('#<%=this.TextServerName.ClientID %>').css('background-image', "none");
	                    $('#<%=this.TextServerAddress.ClientID %>').css('background-image', "none");
	                }

	                if (isValid) { // Validate writability of config file
	                    $.ajax({
	                        type: "POST",
	                        url: "Default.aspx/IsConfigurationFileWritable",
	                        data: "{}",
	                        contentType: "application/json; charset=utf-8",
	                        dataType: "json",
	                        async: false,  // blocks until function returns - race conditions otherwise
	                        success: function (msg) {
	                            if (msg.d == true) {

	                                // Yes, config is writable. Hide "unwritable" div, show "writable" div, all is nice
	                                $('#DivDatabaseUnwritable').css('display', 'none');
	                                $('#DivDatabaseWritable').css('display', 'inline');
	                                $('#<%=this.TextCredentialsReadDatabase.ClientID %>').focus();
	                            } else {
	                                // Config is NOT writable. Keep the error on-screen and keep re-checking every two seconds.

	                                setTimeout('recheckConfigurationWritability();', 5000); // 5s until first re-check
	                                DisableNext();
	                            }
	                        }
	                    });
	                }

	            }
	            else if (stepNumber == 2) {
	                isValid = true; // assume true, make false as we go

	                textBoxes = ["<%=this.TextCredentialsReadDatabase.ClientID %>", "<%=this.TextCredentialsReadServer.ClientID %>", "<%=this.TextCredentialsReadUser.ClientID %>", "<%=this.TextCredentialsReadPassword.ClientID %>",
	                    "<%=this.TextCredentialsWriteDatabase.ClientID %>", "<%=this.TextCredentialsWriteServer.ClientID %>", "<%=this.TextCredentialsWriteUser.ClientID %>", "<%=this.TextCredentialsWritePassword.ClientID %>",
	                    "<%=this.TextCredentialsAdminDatabase.ClientID %>", "<%=this.TextCredentialsAdminServer.ClientID %>", "<%=this.TextCredentialsAdminUser.ClientID %>", "<%=this.TextCredentialsAdminPassword.ClientID %>"];

	                for (loop = 0; loop < textBoxes.length; loop++) {
	                    fieldContents = $('#' + textBoxes[loop]).val();

	                    if (fieldContents && fieldContents.length > 0) {
	                        $('#' + textBoxes[loop]).css('background-image', "none");
	                    } else {
	                        $('#' + textBoxes[loop]).css('background-image', "url('/Images/Icons/iconshock-cross-12px.png')").css('background-position', 'right center').css('background-repeat', 'no-repeat');
	                        isValid = false;
	                    }
	                }

	                // Verify database credentials are good and permissions correct

	                if (isValid) {
	                    DisableNext(); // block Next during synchro call - it may take a while
	                                   // also, won't get re-enabled no matter the outcome
	                    $.ajax({
	                        type: "POST",
	                        url: "Default.aspx/FirstCredentialsTest",
	                        data: "{" +
	                            "'readDatabase':'" + $('#<%=this.TextCredentialsReadDatabase.ClientID %>').val() + "',"+
	                            "'readServer':'" + $('#<%=this.TextCredentialsReadServer.ClientID %>').val() + "',"+
	                            "'readUser':'" + $('#<%=this.TextCredentialsReadUser.ClientID %>').val() + "',"+
	                            "'readPassword':'" + $('#<%=this.TextCredentialsReadPassword.ClientID %>').val() + "',"+
	                            "'writeDatabase':'" + $('#<%=this.TextCredentialsWriteDatabase.ClientID %>').val() + "',"+
	                            "'writeServer':'" + $('#<%=this.TextCredentialsWriteServer.ClientID %>').val() + "',"+
	                            "'writeUser':'" + $('#<%=this.TextCredentialsWriteUser.ClientID %>').val() + "',"+
	                            "'writePassword':'" + $('#<%=this.TextCredentialsWritePassword.ClientID %>').val() + "',"+
	                            "'adminDatabase':'" + $('#<%=this.TextCredentialsAdminDatabase.ClientID %>').val() + "',"+
	                            "'adminServer':'" + $('#<%=this.TextCredentialsAdminServer.ClientID %>').val() + "',"+
	                            "'adminUser':'" + $('#<%=this.TextCredentialsAdminUser.ClientID %>').val() + "',"+
	                            "'adminPassword':'" + $('#<%=this.TextCredentialsAdminPassword.ClientID %>').val() + "',"+
	                            "'serverName':'" + hostName + "'," +
	                            "'ipAddress':'" + hostAddress +"'}",
	                        contentType: "application/json; charset=utf-8",
	                        dataType: "json",
	                        async: false,  // blocks until function returns - race conditions otherwise
	                        success: function (msg) {
	                            if (msg.d.AllPermissionsOk != true) {

	                                // We have a permissions problem. Block further progress and display the problem.
	                                updatePermissionsAnalysisDisplay(msg.d);
	                                $('#DivDatabaseWritable').fadeOut(400, 'swing', function() { $('#DivDatabasePermissionProblem').fadeIn(200); });
	                                setTimeout('recheckDatabasePermissionsAnalysis();', 5000); // 5s until first re-check
	                                isValid = false;
	                            } else {
	                                // re-enable Next only on exit of step 3
	                            }
	                        }
	                    });
                    }


	                if (isValid) {
	                    $('#DivProgressDatabase').progressbar({ value: 0, max: 100 });
	                    setTimeout('updateInitProgressBar();', 1000);
	                    setTimeout('updateInitProgressMessage();', 1500);
	                    beginInitDatabase();
	                    DisableNext();
	                }

	            }
	            else if (stepNumber == 3) {
	                isValid = databaseInitComplete;
	                
                    if (isValid) {
                        $('#<%=this.TextFirstUserName.ClientID %>').focus();
                    }
	            }
	            else if (stepNumber == 4) {
	                isValid = true; // assume true, make false as we go

	                // Check that all four boxes are filled in, and that Password1 and Password2 equal each other.

	                textBoxes = ["<%=this.TextFirstUserName.ClientID %>", "<%=this.TextFirstUserMail.ClientID %>", "<%=this.TextFirstUserPassword1.ClientID %>", "<%=this.TextFirstUserPassword2.ClientID %>"];

	                for (loop = 0; loop < textBoxes.length; loop++) {
	                    fieldContents = $('#' + textBoxes[loop]).val();

	                    if (fieldContents && fieldContents.length > 0) {
	                        $('#' + textBoxes[loop]).css('background-image', "none");
	                    } else {
	                        $('#' + textBoxes[loop]).css('background-image', "url('/Images/Icons/iconshock-cross-12px.png')").css('background-position', 'right center').css('background-repeat', 'no-repeat');
	                        isValid = false;
	                    }
	                }

	                // As we exit the zero-length check, fieldContents contains Password2.Text, so we can compare it to Password1.Text right away.

	                if (isValid) {
	                    if (fieldContents != $('#<%=this.TextFirstUserPassword1.ClientID %>').val()) {
	                        $('#<%=this.TextFirstUserPassword1.ClientID %>').css('background-image', "url('/Images/Icons/iconshock-cross-12px.png')").css('background-position', 'right center').css('background-repeat', 'no-repeat');
	                        $('#<%=this.TextFirstUserPassword2.ClientID %>').css('background-image', "url('/Images/Icons/iconshock-cross-12px.png')").css('background-position', 'right center').css('background-repeat', 'no-repeat');
	                        isValid = false;
	                    }
	                }

	                // If all is valid, create the first user.

	                if (isValid) {
	                    $.ajax({
	                        type: "POST",
	                        url: "Default.aspx/CreateFirstUser",
	                        data: "{'name': '" + escape($('#<%=this.TextFirstUserName.ClientID %>').val()) + "', 'mail': '" + escape($('#<%=this.TextFirstUserMail.ClientID %>').val()) + "', 'password': '" + escape($('#<%=this.TextFirstUserPassword1.ClientID %>').val()) + "'}",
	                        contentType: "application/json; charset=utf-8",
	                        dataType: "json",
	                        success: function (msg) {
	                            // Don't care
	                        }
	                    });
	                }
	            }
	            else if (stepNumber == 5) {
	                // If we get here, we're always good

	                isValid = true;
	            }

	            return isValid;
	        }

	    });  // end of document.ready

	    var disableNext = false;
	    var stopRechecking = false;

	    function DisableNext() {
	        $('a.buttonNext').addClass("buttonDisabled");
	        disableNext = true;
	    }

	    function EnableNext()
	    {
	        $('a.buttonNext').removeClass("buttonDisabled");
	        disableNext = false;
	    }

	    function ClickNext() {
	        $('a.buttonNext').click();
	    }


	    function ReturnToCredentials() {
	        stopRechecking = true;

	        $.ajax({
	            type: "POST",
	            url: "Default.aspx/ResetTestCredentials",
	            data: "{}",
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            success: function (msg) {
	                $('#DivDatabasePermissionProblem').fadeOut(200, 'swing', function () { $('#DivDatabaseWritable').fadeIn(200); EnableNext(); });
	            }
	        });
        }


	    function recheckConfigurationWritability() {

	        $.ajax({
	            type: "POST",
	            url: "Default.aspx/IsConfigurationFileWritable",
	            data: "{}",
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            success: function (msg) {
	                if (msg.d == true) {

	                    // Yes, config is writable. Hide "unwritable" div, show "writable" div, all is nice
	                    $('#DivDatabaseUnwritable').css('display', 'none');
	                    $('#DivDatabaseWritable').fadeIn('slow');
	                    setTimeout('$("#<%=this.TextCredentialsReadDatabase.ClientID %>").focus();', 250);
	                    EnableNext();
	                } else {
	                    // Config is NOT writable. Keep the error on-screen and keep re-checking every two seconds.

	                    setTimeout('recheckConfigurationWritability();', 2000);
	                }
	            }
	        });
	    }

	    function updateInitProgressBar() {

	        $.ajax({
	            type: "POST",
	            url: "Default.aspx/GetInitProgress",
	            data: "{}",
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            success: function (msg) {
	                if (msg.d > 99) {
	                    $("#DivProgressDatabase .ui-progressbar-value").animate(
                            {
                                width: "100%"
                            }, { queue: false });
	                    databaseInitComplete = true;
	                    EnableNext();  // re-enable - it has been disabled throughout Init
	                    ClickNext();
	                } else {
	                    // We're not done yet. Keep the progress bar on-screen and keep re-checking.

	                    if (msg.d == 1) {
	                        $('#DivProgressDatabase').progressbar("value", msg.d);
	                    } else {
	                        $("#DivProgressDatabase .ui-progressbar-value").animate(
                            {
                                width: msg.d + "%"
                            }, { queue: false });
	                    }

	                    setTimeout('updateInitProgressBar();', 1000);
	                }
	            }
	        });
	    }
	    
	    function updateInitProgressMessage() {

	        $.ajax({
	            type: "POST",
	            url: "Default.aspx/GetInitProgressMessage",
	            data: "{}",
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            success: function (msg) {
	                $('#SpanInitProgressMessage').text(msg.d);

	                if (msg.d == 'Complete.') {

	                    // We're done. Do nothing, the progress bar updater will do this step.

	                } else {

	                    // We're not done yet. Keep the progress bar on-screen and keep re-checking.
	                    setTimeout('updateInitProgressMessage();', 500);
	                }
	            }
	        });
	    }


	    function recheckDatabasePermissionsAnalysis() {

	        if (stopRechecking) {
	            stopRechecking = false;
	            return;
	        }

	        $.ajax({
	            type: "POST",
	            url: "Default.aspx/RecheckDatabasePermissions",
	            data: "{}",
	            contentType: "application/json; charset=utf-8",
	            dataType: "json",
	            success: function (msg) {
	                updatePermissionsAnalysisDisplay(msg.d);
	                if (!msg.d.AllPermissionsOk) {
	                    setTimeout('recheckDatabasePermissionsAnalysis();', 2000);
	                } else {
	                    EnableNext();
	                    ClickNext();
	                }
	            }
	        });
	    }

	    function updatePermissionsAnalysisDisplay(testResults) {
	        updateOneDatabasePermissionExpectedSuccess('CellPermissionReadCredentialCanLogin', testResults.ReadCredentialsCanLogin);
	        updateOneDatabasePermissionExpectedSuccess('CellPermissionReadCredentialCanSelect', testResults.ReadCredentialsCanSelect);
	        updateOneDatabasePermissionExpectedFailure('CellPermissionReadCredentialCanExecute', testResults.ReadCredentialsCanExecute);
	        updateOneDatabasePermissionExpectedFailure('CellPermissionReadCredentialCanAdmin', testResults.ReadCredentialsCanAdmin);
	        updateOneDatabasePermissionExpectedSuccess('CellPermissionWriteCredentialCanLogin', testResults.WriteCredentialsCanLogin);
	        updateOneDatabasePermissionExpectedSuccess('CellPermissionWriteCredentialCanSelect', testResults.WriteCredentialsCanSelect);
	        updateOneDatabasePermissionExpectedSuccess('CellPermissionWriteCredentialCanExecute', testResults.WriteCredentialsCanExecute);
	        updateOneDatabasePermissionExpectedFailure('CellPermissionWriteCredentialCanAdmin', testResults.WriteCredentialsCanAdmin);
	        updateOneDatabasePermissionExpectedSuccess('CellPermissionAdminCredentialCanLogin', testResults.AdminCredentialsCanLogin);
	        updateOneDatabasePermissionExpectedSuccess('CellPermissionAdminCredentialCanSelect', testResults.AdminCredentialsCanSelect);
	        updateOneDatabasePermissionExpectedSuccess('CellPermissionAdminCredentialCanExecute', testResults.AdminCredentialsCanExecute);
	        updateOneDatabasePermissionExpectedSuccess('CellPermissionAdminCredentialCanAdmin', testResults.AdminCredentialsCanAdmin);
        }

	    function updateOneDatabasePermissionExpectedSuccess(cellName, result) {
	        if (result) {
	            $('#' + cellName).html('YES <img src="/Images/Icons/iconshock-greentick-16px.png" />');
	        } else {
	            $('#' + cellName).html('NO <img src="/Images/Icons/iconshock-redcross-16px.png" />');
	        }
	    }

	    function updateOneDatabasePermissionExpectedFailure(cellName, result) {
	        if (result) {
	            $('#' + cellName).html('YES <img src="/Images/Icons/iconshock-redcross-16px.png" />');
	        } else {
	            $('#' + cellName).html('NO <img src="/Images/Icons/iconshock-greentick-16px.png" />');
	        }
	    }


	    function beginInitDatabase() {
            $.ajax({
                type: "POST",
                url: "Default.aspx/InitDatabase",
                data: "{}",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function () {
                }
           
            });
        }


	</script>
	
    <!-- Main menu, dynamically constructed -->

	<div class="center980px">
	    <div class="currentuserinfo"><div style="background-image:url('/Images/Icons/iconshock-user-16px.png');background-repeat:no-repeat;padding-left:16px;float:left"><asp:Label ID="LabelCurrentUserName" runat="server" /> | </div><div style="background-image:url('/Images/Icons/iconshock-workchair-16px.png');background-repeat:no-repeat;padding-left:17px;float:left"><asp:Label ID="LabelCurrentOrganizationName" runat="server" /> |&nbsp;</div><div style="background-image:url('/Images/Icons/iconshock-gamepad-16px.png');background-repeat:no-repeat;padding-left:20px;float:left"><asp:Label ID="LabelPreferences" runat="server" /> |&nbsp;</div><asp:Image ID="ImageCultureIndicator" runat="server" ImageUrl="~/Images/Flags/uk.png" /></div>
        <div class="logoimage"><a href="/"><img style="border:none" src="/Style/Images/Logo-Stock.png" alt="Swarmops Logo" /></a></div>
        <div class="break"></div>
        <div class="topmenu">
            <div class="searchbox"><asp:TextBox ID="SearchBox" runat="server" /></div>
        </div>
        
        <div class="mainbar">
            <div id="page-icon-encaps"><asp:Image ID="IconPage" runat="server" ImageUrl="~/Images/PageIcons/iconshock-ignitionkey-40px.png" /></div><h1><asp:Label ID="LabelPageTitle" Text="Installation" runat="server" /></h1>
        
        <div class="box">
            <div class="content">
                
                <div id="wizard" class="swMain">
  			        <ul>
  				        <li><a href="#step-1">
                        <label class="stepNumber">1</label>
                        <span class="stepDesc">
                           Security Check<br />
                           <small>Are you the admin of this server?</small>
                        </span>                   
                    </a></li>
  				        <li><a href="#step-2">
                        <label class="stepNumber">2</label>
                        <span class="stepDesc">
                           Database<br />
                           <small>Supply database credentials and connect</small>
                        </span>
                    </a></li>
  				        <li><a href="#step-3">
                        <label class="stepNumber">3</label>
                        <span class="stepDesc">
                           Populate<br />
                           <small>Wait while bootstrap data is loaded</small>
                        </span>                   
                     </a></li>
  				        <li><a href="#step-4">
                        <label class="stepNumber">4</label>
                        <span class="stepDesc">
                           User Data<br />
                           <small>Let's create the first user</small>
                        </span>                   
                     </a></li>
  				        <li><a href="#step-5">
                        <label class="stepNumber">5</label>
                        <span class="stepDesc">
                           Complete<br />
                           <small>All done. Let's login!</small>
                        </span>                   
                    </a></li>
  			        </ul>
  			        <div id="step-1">	
                        <h2>Welcome to Swarmops</h2>
                        <p>Congratulations! Since you're reading this, you have successfully installed the Swarmops packages and set up an Apache virtual server using mod_mono.</p>

  			            <p>However, before we proceed, we need to make sure that you are indeed the sysadmin of this server, and not a remote bot who just discovered an unfinished Swarmops installation. To cross that bridge, answer these three simple questions:</p> <asp:Label runat="server" ID="LabelTest" />
                        
                        <div class="entryLabelsAdmin" style="width:250px">
                            What is this server's /etc/hostname?<br />
  			                What is this server's internal IP?<br />
                            What is your favorite color?
                        </div>
                        <div class="entryFieldsAdmin">
                            <asp:TextBox CssClass="textinput" ID="TextServerName" runat="server" />&nbsp;<br />
                            <asp:TextBox CssClass="textinput"  ID="TextServerAddress" runat="server" />&nbsp;<br />
                            <asp:DropDownList ID="DropFavoriteColor" runat="server" />&nbsp;<br />
                        </div>
                    </div>
  			        <div id="step-2">
  			            <div id="DivDatabaseUnwritable">
  			            <h2>Fix File Permissions</h2>
                        <asp:Image ImageUrl="~/Images/Icons/iconshock-cross-96px.png" ID="FailWriteConfig" runat="server" ImageAlign="Left" /><p>The bad news is that we can't write to the configuration file. This is fairly normal for a new installation. The good news is that you can fix that, so we can continue installing. Please open a shell to the Swarmops server and execute the following commands:</p><br/>
                        <p><strong>cd /etc/swarmops<br/>sudo chown www-data:www-data database.config</strong></p>
                        <p>The installation will continue when it detects that these steps have been taken.</p>
  			            </div>
  			            <div id="DivDatabasePermissionProblem" style="display:none">
  			            <h2>Fix Database Permissions</h2>
                        <asp:Image ImageUrl="~/Images/Icons/iconshock-cross-96px.png" ID="Image1" runat="server" ImageAlign="Left" /><p>There seems to be an error with the database credentials, or more likely, the permissions for those credentials. <strong>Edit the database permissions until you have green ticks in all boxes below.</strong> (If you made a mistake filling in the database credentials, you can <a href="javascript:ReturnToCredentials();">return to entering credentials</a>.)</p>
                        <p>The installation will continue when it detects this has been corrected, and the table below will update continuously as you change database permissions.</p>
                              <table>
                                  <thead><tr><th>&nbsp;</th><th>Can login?</th><th>Can SELECT?</th><th>Can EXECUTE?</th><th>Can alter schema?</th></tr></thead>
                                  <tr>
                                      <td class="PermissionsErrorCredentials">Read credentials</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionReadCredentialCanLogin">&nbsp;</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionReadCredentialCanSelect">&nbsp;</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionReadCredentialCanExecute">&nbsp;</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionReadCredentialCanAdmin">&nbsp;</td>
                                  </tr>
                                  <tr>
                                      <td class="PermissionsErrorCredentials">Write credentials</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionWriteCredentialCanLogin">&nbsp;</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionWriteCredentialCanSelect">&nbsp;</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionWriteCredentialCanExecute">&nbsp;</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionWriteCredentialCanAdmin">&nbsp;</td>
                                  </tr>
                                  <tr>
                                      <td class="PermissionsErrorCredentials">Admin credentials</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionAdminCredentialCanLogin">&nbsp;</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionAdminCredentialCanSelect">&nbsp;</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionAdminCredentialCanExecute">&nbsp;</td>
                                      <td class="PermissionsErrorResults" id="CellPermissionAdminCredentialCanAdmin">&nbsp;</td>
                                  </tr>
                              </table>
  			            </div>
                        <div id="DivDatabaseWritable" style="display:none">
                            <h2>Connect to database</h2>	
                            <p>Before you fill this in, you will need to have created a database on a MySQL server that this web server can access, and set up user accounts that can access it. For security reasons, we <strong>require</strong> having three separate accounts - one for reading (SELECT permissions only), one for writing (SELECT and EXECUTE), and one for admin. All three accounts also need SELECT permissions on the mysql database.</p>

                            <div class="entryLabelsAdmin" style="width:120px">
                                &nbsp;<br/>
                                Database<br />
  			                    Server<br />
                                User<br/>
                                Password
                            </div>
                            <div class="entryFieldsAdmin" style="width:80px">
                                <strong>Read access</strong><br/>
                                <asp:TextBox CssClass="textinput" ID="TextCredentialsReadDatabase" runat="server" />&nbsp;<br />
                                <asp:TextBox CssClass="textinput"  ID="TextCredentialsReadServer" runat="server" />&nbsp;<br />
                                <asp:TextBox CssClass="textinput"  ID="TextCredentialsReadUser" runat="server" />&nbsp;<br />
                                <asp:TextBox CssClass="textinput"  ID="TextCredentialsReadPassword" TextMode="Password" runat="server" />&nbsp;<br />
                            </div>
                            <div class="entryFieldsAdmin" style="width:80px;margin-left:10px">
                                <strong>Write access</strong><br/>
                                <asp:TextBox CssClass="textinput" ID="TextCredentialsWriteDatabase" runat="server" />&nbsp;<br />
                                <asp:TextBox CssClass="textinput"  ID="TextCredentialsWriteServer" runat="server" />&nbsp;<br />
                                <asp:TextBox CssClass="textinput"  ID="TextCredentialsWriteUser" runat="server" />&nbsp;<br />
                                <asp:TextBox CssClass="textinput"  ID="TextCredentialsWritePassword" TextMode="Password" runat="server" />&nbsp;<br />
                            </div>
                            <div class="entryFieldsAdmin" style="width:80px;margin-left:10px">
                                <strong>Admin access</strong><br/>
                                <asp:TextBox CssClass="textinput" ID="TextCredentialsAdminDatabase" runat="server" />&nbsp;<br />
                                <asp:TextBox CssClass="textinput"  ID="TextCredentialsAdminServer" runat="server" />&nbsp;<br />
                                <asp:TextBox CssClass="textinput"  ID="TextCredentialsAdminUser" runat="server" />&nbsp;<br />
                                <asp:TextBox CssClass="textinput"  ID="TextCredentialsAdminPassword" TextMode="Password" runat="server" />&nbsp;<br />
                            </div>
                        </div>
                    </div>                      
  			        <div id="step-3">
  			            <h2>Initializing database</h2>
                        <div id="DivProgressDatabase"></div>
                        <p>Please wait while the database is being initialized with schemas and geographic data from the Swarmops servers. This is going to take a <strong>significant</strong> amount of time; we're loading tons of geodata onto your new server.</p>
                        <p><span id="SpanInitProgressMessage">Initializing...</span></p>
                    </div>
                    <div id="step-4">
                        <h2>Creating the first user</h2>	
                        <p>Your new Swarmops server has been loaded with the geographic layout of the countries we're active in, and the first organization - the <em>Sandbox</em> - has been created. We are now going to create your user account, which will become the systems administrator account of this Swarmops installation.</p>
                        
                        <p>(You can add other people to the <em>System Administrator</em> role later.)</p>

                        <div class="entryLabelsAdmin" style="width:250px">
                            Your full name<br />
  			                Your email<br />
                            Your password<br/>
                            Repeat password
                        </div>
                        <div class="entryFieldsAdmin">
                            <asp:TextBox CssClass="textinput" ID="TextFirstUserName" runat="server" />&nbsp;<br />
                            <asp:TextBox CssClass="textinput"  ID="TextFirstUserMail" runat="server" />&nbsp;<br />
                            <asp:TextBox CssClass="textinput"  ID="TextFirstUserPassword1" TextMode="Password" runat="server" />&nbsp;<br />
                            <asp:TextBox CssClass="textinput"  ID="TextFirstUserPassword2" TextMode="Password" runat="server" />&nbsp;<br />
                        </div>
                    </div>
  			        <div id="step-5" style="display:none">
                        <h2>All done - ready to login</h2>	
                        <p>Your Swarmops installation is ready! Press Finish to log in as your new user and start using it.</p>
                        <div style="display:none"><asp:Button runat="server" ID="ButtonLogin" OnClick="ButtonLogin_Click" Text="This button is invisible."/></div>
                    </div>
      		    </div>

                <asp:Label ID="LabelDashboardTemporaryContent" runat="server" /> <a href="/Pages/v5/Governance/Vote.aspx"><asp:Label ID="LabelGoThere2" runat="server" /></a>
            </div>
        </div>
        
        </div>
        <div class="sidebar">
    <h2 class="blue"><asp:Label ID="LabelSidebarInfoHeader" runat="server" /><span class="arrow"></span></h2>
    
    <div class="box">
        <div class="content">
        <asp:Label ID="LabelSidebarInfoContent" runat="server" />
        </div>
    </div>
    
    <h2 class="blue"><asp:Label ID="LabelSidebarActionsHeader" runat="server" /><span class="arrow"></span></h2>
    
    <div class="box">
        <div class="content">
            <asp:Label ID="LabelSidebarActionsContent" runat="server" />
        </div>
    </div>
    
    <h2 class="orange"><asp:Label ID="LabelSidebarTodoHeader" runat="server" /><span class="arrow"></span></h2>
    
    <div class="box">
        <div class="content">
            <div class="link-row-encaps" onclick="return false;" >
                <div class="link-row-icon" style="background-image:url('/Images/Icons/iconshock-databaseconnect-16px.png')"></div>
                <asp:Label ID="LabelSidebarTodoConnectDatabase" runat="server" />
            </div>
        </div>
    </div>
        </div>
        
	</div>

	</form>
</body>
</html>





        


