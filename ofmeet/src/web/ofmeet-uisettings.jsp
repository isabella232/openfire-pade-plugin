<%--
  ~ Copyright (c) 2017 Ignite Realtime Foundation. All rights reserved.
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~      http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
  --%>
<%@ page import="org.jivesoftware.openfire.plugin.ofmeet.*" %>
<%@ page import="org.jivesoftware.openfire.*" %>
<%@ page import="org.jivesoftware.util.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.MalformedURLException" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="admin" prefix="admin" %>
<jsp:useBean id="ofmeetConfig" class="org.igniterealtime.openfire.plugin.ofmeet.config.OFMeetConfig"/>
<%
    boolean update = request.getParameter("update") != null;

    final Cookie csrfCookie = CookieUtils.getCookie( request, "csrf" );
    final String csrfParam = ParamUtils.getParameter( request, "csrf" );

    // Get handle on the plugin
    final OfMeetPlugin container = (OfMeetPlugin) XMPPServer.getInstance().getPluginManager().getPlugin("ofmeet");

    final Map<String, String> errors = new HashMap<>();

    if ( update )
    {
        if ( csrfCookie == null || csrfParam == null || !csrfCookie.getValue().equals( csrfParam ) )
        {
            errors.put( "csrf", "CSRF Failure!" );
        }

        final String cryptpadurl = request.getParameter( "cryptpadurl" );
        final String whiteboardurl = request.getParameter( "whiteboardurl" );                

        final String webappContextPath = request.getParameter( "webappcontextpath" );
        if ( webappContextPath != null && !StringUtils.escapeHTMLTags( webappContextPath ).equals( webappContextPath ) )
        {
            errors.put( "webappContextPath", "Illegal value" );
        }

        final String applicationName = request.getParameter( "applicationName" );
        final String activeSpkrAvatarSize = request.getParameter( "activeSpkrAvatarSize" );
        try {
            Integer.parseInt( activeSpkrAvatarSize );
        } catch (NumberFormatException ex ) {
            errors.put( "activeSpkrAvatarSize", "Cannot parse value as integer value." );
        }

        final String canvasExtra = request.getParameter( "canvasExtra" );
        try {
            Integer.parseInt( canvasExtra );
        } catch (NumberFormatException ex ) {
            errors.put( "canvasExtra", "Cannot parse value as integer value." );
        }

        final String canvasRadius = request.getParameter( "canvasRadius" );
        try {
            Integer.parseInt( canvasRadius );
        } catch (NumberFormatException ex ) {
            errors.put( "canvasRadius", "Cannot parse value as integer value." );
        }
        
        final String tileviewColumns = request.getParameter( "tileviewColumns" );
        try {
            Integer.parseInt( tileviewColumns );
        } catch (NumberFormatException ex ) {
            errors.put( "tileviewColumns", "Cannot parse value as integer value." );
        }
        
        final String shadowColor = request.getParameter( "shadowColor" );
        final String initialToolbarTimeout = request.getParameter( "initialToolbarTimeout" );
        try {
            Long.parseLong( initialToolbarTimeout );
        } catch (NumberFormatException ex ) {
            errors.put( "initialToolbarTimeout", "Cannot parse value as long value." );
        }

        final String toolbarTimeout = request.getParameter( "toolbarTimeout" );
        try {
            Long.parseLong( toolbarTimeout );
        } catch (NumberFormatException ex ) {
            errors.put( "toolbarTimeout", "Cannot parse value as long value." );
        }

        int filmstripMaxHeight = ofmeetConfig.getFilmstripMaxHeight();
        try {
            filmstripMaxHeight = Integer.parseInt( request.getParameter( "filmstripMaxHeight" ) );
        } catch (NumberFormatException ex) {
            errors.put( "filmstripMaxHeight", "Cannot parse value as int value." );
        }
        final boolean verticalFilmstrip = ParamUtils.getBooleanParameter( request, "verticalFilmstrip" );
        final boolean filmstripOnly = ParamUtils.getBooleanParameter( request, "filmstripOnly" );;

        final String defRemoteDisplName = request.getParameter( "defRemoteDisplName" );
        final String defDomSpkrDisplName = request.getParameter( "defDomSpkrDisplName" );
        final String defLocalDisplName = request.getParameter( "defLocalDisplName" );

        final boolean showPoweredBy = ParamUtils.getBooleanParameter( request, "showPoweredBy" );
        final boolean enablePreJoinPage = ParamUtils.getBooleanParameter( request, "enablePreJoinPage" );
        final boolean conferenceRecording = ParamUtils.getBooleanParameter( request, "conferenceRecording" );
        final boolean conferenceTags = ParamUtils.getBooleanParameter( request, "conferenceTags" );
        final boolean enableCryptPad = ParamUtils.getBooleanParameter( request, "enableCryptPad" );    
        final boolean enableWhiteboard = ParamUtils.getBooleanParameter( request, "enableWhiteboard" );          
        final boolean enableConfetti = ParamUtils.getBooleanParameter( request, "enableConfetti" );          
        final boolean cachePassword = ParamUtils.getBooleanParameter( request, "cachePassword" );     
        final boolean showCaptions = ParamUtils.getBooleanParameter( request, "showCaptions" );        
        final boolean enableTranscription = ParamUtils.getBooleanParameter( request, "enableTranscription" );  
        final boolean contactManager = ParamUtils.getBooleanParameter( request, "contactManager" );  
        final boolean allowUploads = ParamUtils.getBooleanParameter( request, "allowUploads" );           
        final boolean enableBreakout = ParamUtils.getBooleanParameter( request, "enableBreakout" ); 
        
        final boolean welcomepageContent = ParamUtils.getBooleanParameter( request, "welcomepageContent" );
        final boolean welcomepageToolbarContent = ParamUtils.getBooleanParameter( request, "welcomepageToolbarContent" );
        final String welcomeTitle = ParamUtils.getParameter( request, "welcomeTitle" );      
        final String welcomeDesc = ParamUtils.getParameter( request, "welcomeDesc" );          
        final String welcomeContent = ParamUtils.getParameter( request, "welcomeContent" );
        final String welcomeToolbarContent = ParamUtils.getParameter( request, "welcomeToolbarContent" );
        
        final String language = ParamUtils.getParameter( request, "language" );                
        final boolean enableLanguageDetection = ParamUtils.getBooleanParameter( request, "enableLanguageDetection" );  
        
        final boolean randomRoomNames = ParamUtils.getBooleanParameter( request, "randomRoomNames" );
        final boolean lipSync = ParamUtils.getBooleanParameter( request, "lipSync" );

        final boolean showWatermark = ParamUtils.getBooleanParameter( request, "showWatermark" );
        final String watermarkLogoUrlValue = request.getParameter( "watermarkLogoUrl" );
        URL watermarkLogoUrl = null;
        if ( watermarkLogoUrlValue != null && !watermarkLogoUrlValue.isEmpty() )
        {
            try {
                watermarkLogoUrl = new URL( watermarkLogoUrlValue );
            } catch ( MalformedURLException e ) {
                errors.put( "watermarkLogoUrl", "Cannot parse value as a URL." );
            }
        }
        final String watermarkLink = request.getParameter( "watermarkLink" );

        final boolean brandShowWatermark = ParamUtils.getBooleanParameter( request, "brandShowWatermark" );
        URL brandWatermarkLogoUrl = null;
        final String brandWatermarkLogoUrlValue = request.getParameter( "brandWatermarkLogoUrl" );
        if ( brandWatermarkLogoUrlValue != null && !brandWatermarkLogoUrlValue.isEmpty() )
        {
            try {
                brandWatermarkLogoUrl = new URL( brandWatermarkLogoUrlValue );
            } catch ( MalformedURLException e ) {
                errors.put( "brandWatermarkLogoUrl", "Cannot parse value as a URL." );
            }
        }
        final String brandWatermarkLink = request.getParameter( "brandWatermarkLink" );

        // Buttons
        final List<String> buttonsEnabled = new ArrayList<>();
        for ( final String buttonName : ofmeetConfig.getButtonsImplemented() )
        {
            final boolean buttonEnabled = ParamUtils.getBooleanParameter( request, "button-enabled-" + buttonName );
            if ( buttonEnabled )
            {
                buttonsEnabled.add( buttonName );
            }
        }

        if ( errors.isEmpty() )
        {
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.application.name", applicationName );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.active.speaker.avatarsize", activeSpkrAvatarSize );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.canvas.extra", canvasExtra );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.canvas.radius", canvasRadius );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.tileview.columns.max", tileviewColumns );            
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.shadow.color", shadowColor );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.initial.toolbar.timeout", initialToolbarTimeout );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.toolbar.timeout", toolbarTimeout );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.default.remote.displayname", defRemoteDisplName );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.default.speaker.displayname", defDomSpkrDisplName );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.default.local.displayname", defLocalDisplName );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.show.poweredby", Boolean.toString( showPoweredBy ) );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.enable.prejoin.page", Boolean.toString( enablePreJoinPage ) );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.conference.recording", Boolean.toString( conferenceRecording ) );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.conference.tags", Boolean.toString( conferenceTags ) );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.enable.cryptpad", Boolean.toString( enableCryptPad ) ); 
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.enable.whiteboard", Boolean.toString( enableWhiteboard ) );             
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.enable.confetti", Boolean.toString( enableConfetti ) );             
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.cache.password", Boolean.toString( cachePassword ) ); 
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.show.captions", Boolean.toString( showCaptions ) ); 
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.enable.transcription", Boolean.toString( enableTranscription  ) );                        
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.contacts.manager", Boolean.toString( contactManager  ) );                        
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.allow.uploads", Boolean.toString( allowUploads ) );             
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.enable.breakout", Boolean.toString( enableBreakout ) );              
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.random.roomnames", Boolean.toString( randomRoomNames ) );            
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.welcomepage.content", Boolean.toString( welcomepageContent ) );            
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.welcomepage.toolbarcontent", Boolean.toString( welcomepageToolbarContent ) );            
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.welcomepage.title",  welcomeTitle );     
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.welcomepage.description",  welcomeDesc );  
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.welcome.content",  welcomeContent );              
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.welcome.toolbarcontent", welcomeToolbarContent );            
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.enable.languagedetection", Boolean.toString( enableLanguageDetection ) );            
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.default.language", language );             
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.watermark.link", watermarkLink );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.show.watermark", Boolean.toString( showWatermark ) );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.brand.watermark.link", brandWatermarkLink );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.brand.show.watermark", Boolean.toString( brandShowWatermark ) );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.cryptpad.url", cryptpadurl );
            JiveGlobals.setProperty( "org.jitsi.videobridge.ofmeet.whiteboard.url", whiteboardurl );            

            ofmeetConfig.setWebappContextPath( webappContextPath );
            ofmeetConfig.setFilmstripMaxHeight( filmstripMaxHeight );
            ofmeetConfig.setVerticalFilmstrip( verticalFilmstrip );
            ofmeetConfig.setFilmstripOnly( filmstripOnly );

            ofmeetConfig.setLipSync( lipSync );
            ofmeetConfig.setWatermarkLogoUrl( watermarkLogoUrl );
            ofmeetConfig.setBrandWatermarkLogoUrl( brandWatermarkLogoUrl );

            ofmeetConfig.setButtonsEnabled( buttonsEnabled );

            container.populateJitsiSystemPropertiesWithJivePropertyValues();

            response.sendRedirect( "ofmeet-uisettings.jsp?settingsSaved=true" );
            return;
        }
    }

    final String csrf = StringUtils.randomString( 15 );
    CookieUtils.setCookie( request, response, "csrf", csrf, -1 );

    pageContext.setAttribute( "csrf", csrf );
    pageContext.setAttribute( "errors", errors );
    pageContext.setAttribute( "webappURL", container.getWebappURL() );
%>
<html>
<head>
    <title><fmt:message key="config.page.uisettings.title" /></title>
    <meta name="pageID" content="ofmeet-uisettings"/>
</head>
<body>

<c:choose>
    <c:when test="${not empty param.settingsSaved and empty errors}">
        <admin:infoBox type="success"><fmt:message key="config.page.configuration.save.success" /></admin:infoBox>
    </c:when>
    <c:otherwise>
        <c:forEach var="err" items="${errors}">
            <admin:infobox type="error">
                <c:choose>
                    <c:when test="${err.key eq 'csrf'}"><fmt:message key="global.csrf.failed"/></c:when>
                    <c:otherwise>
                        <c:if test="${not empty err.value}">
                            <c:out value="${err.value}"/>
                        </c:if>
                        (<c:out value="${err.key}"/>)
                    </c:otherwise>
                </c:choose>
            </admin:infobox>
        </c:forEach>
    </c:otherwise>
</c:choose>

<p><fmt:message key="config.page.uisettings.introduction" /></p>

<form action="ofmeet-uisettings.jsp" method="post">

    <fmt:message key="config.page.configuration.connectivity.title" var="boxtitleConnectivity"/>
    <admin:contentBox title="${boxtitleConnectivity}">
        <p>
            <fmt:message key="config.page.configuration.connectivity.description">
                <fmt:param value="${webappURL}"/>
            </fmt:message>
        </p>
        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr>
                <td width="200"><fmt:message key="ofmeet.connectivity.webappcontextpath"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="webappcontextpath" value="${ofmeetConfig.webappContextPath}"></td>
            </tr>            
        </table>
    </admin:contentBox>      
        
    <fmt:message key="config.page.configuration.ui.title" var="boxtitleUI"/>
    <admin:contentBox title="${boxtitleUI}">
        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr>
                <td width="200"><fmt:message key="ofmeet.application.name"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="applicationName" value="${admin:getProperty("org.jitsi.videobridge.ofmeet.application.name", "Pade Meetings")}"></td>
            </tr>
            <tr>
                <td width="200"><fmt:message key="ofmeet.active.speaker.avatarsize"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="activeSpkrAvatarSize" value="${admin:getIntProperty("org.jitsi.videobridge.ofmeet.active.speaker.avatarsize", 100)}"></td>
            </tr>
            <tr>
                <td width="200"><fmt:message key="ofmeet.canvas.extra"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="canvasExtra" value="${admin:getIntProperty("org.jitsi.videobridge.ofmeet.canvas.extra", 104)}"></td>
            </tr>
            <tr>
                <td width="200"><fmt:message key="ofmeet.canvas.radius"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="canvasRadius" value="${admin:getIntProperty("org.jitsi.videobridge.ofmeet.canvas.radius", 7)}"></td>
            </tr>
            <tr>
                <td width="200"><fmt:message key="ofmeet.tileview.columns.max"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="tileviewColumns" value="${admin:getIntProperty("org.jitsi.videobridge.ofmeet.tileview.columns.max", 5)}"></td>
            </tr>            
            <tr>
                <td width="200"><fmt:message key="ofmeet.shadow.color"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="shadowColor" value="${admin:getProperty("org.jitsi.videobridge.ofmeet.shadow.color", "#ffffff")}"></td>
            </tr>
            <tr>
                <td width="200"><fmt:message key="ofmeet.default.remote.displayname"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="defRemoteDisplName" value="${admin:getProperty("org.jitsi.videobridge.ofmeet.default.remote.displayname", "Change Me")}"></td>
            </tr>
            <tr>
                <td width="200"><fmt:message key="ofmeet.default.speaker.displayname"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="defDomSpkrDisplName" value="${admin:getProperty("org.jitsi.videobridge.ofmeet.default.speaker.displayname", "Speaker")}"></td>
            </tr>
            <tr>
                <td width="200"><fmt:message key="ofmeet.default.local.displayname"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="defLocalDisplName" value="${admin:getProperty("org.jitsi.videobridge.ofmeet.default.local.displayname", "Me")}"></td>
            </tr>
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="showPoweredBy" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.show.poweredby", false) ? "checked" : ""}>
                    <fmt:message key="ofmeet.show.poweredby.enabled" />
                </td>
            </tr>
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="enablePreJoinPage" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.enable.prejoin.page", false) ? "checked" : ""}>
                    <fmt:message key="ofmeet.enable.prejoin.page" />
                </td>
            </tr>            
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="cachePassword" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.cache.password", true) ? "checked" : ""}>
                    <fmt:message key="ofmeet.cache.password" />
                </td>
            </tr>                               
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="randomRoomNames" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.random.roomnames", true) ? "checked" : ""}>
                    <fmt:message key="ofmeet.random.roomnames.enabled" />
                </td>
            </tr>
           <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="enableLanguageDetection" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.enable.languagedetection", false) ? "checked" : ""}>
                    <fmt:message key="ofmeet.enable.languagedetection" />
                </td>
            </tr>            
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="lipSync" ${ofmeetConfig.lipSync ? "checked" : ""}>
                    <fmt:message key="ofmeet.lipSync.enabled" />
                </td>
            </tr>
        </table>
    </admin:contentBox>
    
    <fmt:message key="config.page.applications.title" var="boxtitleApps"/>
    <admin:contentBox title="${boxtitleApps}">
        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr>
                <td width="200"><fmt:message key="ofmeet.cryptpad.url"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="cryptpadurl" value="${admin:getProperty("org.jitsi.videobridge.ofmeet.cryptpad.url", "https://cryptpad.fr")}"></td>
            </tr>
            <tr>
                <td width="200"><fmt:message key="ofmeet.whiteboard.url"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="whiteboardurl" value="${admin:getProperty("org.jitsi.videobridge.ofmeet.whiteboard.url", "https://wbo.ophir.dev/boards/")}"></td>
            </tr>   
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="enableCryptPad" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.enable.cryptpad", true) ? "checked" : ""}>
                    <fmt:message key="ofmeet.enable.cryptpad" />
                </td>
            </tr> 
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="enableWhiteboard" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.enable.whiteboard", true) ? "checked" : ""}>
                    <fmt:message key="ofmeet.enable.whiteboard" />
                </td>
            </tr>    
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="enableConfetti" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.enable.confetti", true) ? "checked" : ""}>
                    <fmt:message key="ofmeet.enable.confetti" />
                </td>
            </tr>             
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="conferenceRecording" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.conference.recording", true) ? "checked" : ""}>
                    <fmt:message key="ofmeet.conference.recording" />
                </td>
            </tr>
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="conferenceTags" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.conference.tags", true) ? "checked" : ""}>
                    <fmt:message key="ofmeet.conference.tags" />
                </td>
            </tr>  
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="enableBreakout" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.enable.breakout", false) ? "checked" : ""}>
                    <fmt:message key="ofmeet.enable.breakout" />
                </td>
            </tr>            
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="allowUploads" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.allow.uploads", true) ? "checked" : ""}>
                    <fmt:message key="ofmeet.allow.uploads" />
                </td>
            </tr>   
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="showCaptions" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.show.captions", false) ? "checked" : ""}>
                    <fmt:message key="ofmeet.show.captions" />
                </td>
            </tr>    
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="enableTranscription" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.enable.transcription", false) ? "checked" : ""}>
                    <fmt:message key="ofmeet.enable.transcription" />
                </td>
            </tr>                            
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="contactManager" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.contacts.manager", false) ? "checked" : ""}>
                    <fmt:message key="ofmeet.contacts.manager" />
                </td>
            </tr>            
        </table>
    </admin:contentBox>      
    
    <fmt:message key="config.page.configuration.language.title" var="boxtitleLanguage"/>
    <admin:contentBox title="${boxtitleLanguage}">
        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <tbody>
            <c:forEach items="${ofmeetConfig.languages}" var="language">
            <tr valign="top">
                <td width="1%" nowrap>
                    <input type="radio" name="language" value="${language.getCode()}" id="${language.getCode()}" ${(ofmeetConfig.language == language ? "checked" : "")}>
                </td>
                <td width="99%">
                    <label for="${language.getCode()}">${language}</label>
                </td>
            </tr>
            </c:forEach>
            </tbody>
        </table>
    </admin:contentBox>

    <fmt:message key="ofmeet.welcome.title" var="boxtitleWelcome"/>
    <admin:contentBox title="${boxtitleWelcome}">
        <p><fmt:message key="ofmeet.welcome.description"/></p><br/>
        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr>
                <td width="200"><fmt:message key="ofmeet.welcomepage.title"/>:</td>
                <td><textarea placeholder="<fmt:message key="ofmeet.welcomepage.title.placeholder"/>" cols="60" rows="5" name="welcomeTitle">${admin:getProperty( "org.jitsi.videobridge.ofmeet.welcomepage.title", "Pade Meetings")}</textarea></td>
            </tr>  
            <tr>
                <td width="200"><fmt:message key="ofmeet.welcomepage.description"/>:</td>
                <td><textarea placeholder="<fmt:message key="ofmeet.welcomepage.description.placeholder"/>" cols="60" rows="5" name="welcomeDesc">${admin:getProperty( "org.jitsi.videobridge.ofmeet.welcomepage.description", "")}</textarea></td>
            </tr>             
            <tr>
                <td width="200"><fmt:message key="ofmeet.welcome.content"/>:</td>
                <td><textarea placeholder="<fmt:message key="ofmeet.welcome.content.placeholder"/>" cols="60" rows="5" name="welcomeContent">${admin:getProperty( "org.jitsi.videobridge.ofmeet.welcome.content", "")}</textarea></td>
            </tr>  
            <tr>
                <td width="200"><fmt:message key="ofmeet.welcome.toolbarcontent"/>:</td>
                <td><textarea placeholder="<fmt:message key="ofmeet.welcome.toolbarcontent.placeholder"/>" cols="60" rows="5" name="welcomeToolbarContent">${admin:getProperty( "org.jitsi.videobridge.ofmeet.welcome.toolbarcontent", "")}</textarea></td>
            </tr>             
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="welcomepageContent" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.welcomepage.content", true) ? "checked" : ""}>
                    <fmt:message key="ofmeet.welcomepage.content" />
                </td>
            </tr>            
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="welcomepageToolbarContent" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.welcomepage.toolbarcontent", false) ? "checked" : ""}>
                    <fmt:message key="ofmeet.welcomepage.toolbarcontent" />
                </td>
            </tr>
        </table>
    </admin:contentBox>
    
    <fmt:message key="ofmeet.filmstrip.title" var="boxtitleFilmstrip"/>
    <admin:contentBox title="${boxtitleFilmstrip}">
        <p><fmt:message key="ofmeet.filmstrip.description"/></p>
        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr>
                <td width="200"><fmt:message key="ofmeet.filmstrip.max.height"/>:</td>
                <td><input type="text" size="60" maxlength="100" name="filmstripMaxHeight" value="${ofmeetConfig.filmstripMaxHeight}"></td>
            </tr>
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="verticalFilmstrip" ${ofmeetConfig.verticalFilmstrip ? "checked" : ""}>
                    <fmt:message key="ofmeet.verticalFilmstrip.enabled" />
                </td>
            </tr>
            <tr>
                <td nowrap colspan="2">
                    <input type="checkbox" name="filmstripOnly" ${ofmeetConfig.filmstripOnly ? "checked" : ""}>
                    <fmt:message key="ofmeet.filmstripOnly.enabled" />
                </td>
            </tr>
        </table>
    </admin:contentBox>

    <fmt:message key="ofmeet.toolbar.title" var="boxtitleToolbar"/>
    <admin:contentBox title="${boxtitleToolbar}">
        <p><fmt:message key="ofmeet.toolbar.timeout.description"/></p>
        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr>
                <td width="200"><fmt:message key="ofmeet.initial.toolbar.timeout"/>:</td>
                <td><input type="text" size="10" maxlength="20" name="initialToolbarTimeout" value="${admin:getLongProperty("org.jitsi.videobridge.ofmeet.initial.toolbar.timeout", 20000)}"></td>
            </tr>
            <tr>
                <td width="200"><fmt:message key="ofmeet.toolbar.timeout"/>:</td>
                <td><input type="text" size="10" maxlength="20" name="toolbarTimeout" value="${admin:getLongProperty("org.jitsi.videobridge.ofmeet.toolbar.timeout", 4000)}"></td>
            </tr>
        </table>
        <br/>
        <p><fmt:message key="ofmeet.toolbar.buttons.description"/></p>
        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <c:forEach items="${ofmeetConfig.buttonsImplemented}" var="buttonName">
                <tr>
                    <td>
                        <input type="checkbox" name="button-enabled-${buttonName}" ${ofmeetConfig.buttonsEnabled.contains( buttonName ) ? 'checked': ''}>
                        <fmt:message key="ofmeet.toolbar.button.${buttonName}.description"/>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </admin:contentBox>

    <fmt:message key="ofmeet.watermark.title" var="boxtitleWatermarks"/>
    <admin:contentBox title="${boxtitleWatermarks}">
        <p><fmt:message key="ofmeet.watermark.description"/></p>
        <table cellpadding="3" cellspacing="0" border="0" width="100%">
            <tr>
                <td colspan="3" nowrap>
                    <input type="checkbox" name="showWatermark" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.show.watermark", false) ? "checked" : ""}>
                    <fmt:message key="ofmeet.show.watermark.enabled" />
                </td>
            </tr>
            <tr>
                <td width="15"></td>
                <td>
                    <fmt:message key="ofmeet.watermark.logo.url"/>:
                </td>
                <td>
                    <input type="text" size="60" maxlength="100" name="watermarkLogoUrl" placeholder="https:/meet.jit.si/images/watermark.png" value="${ofmeetConfig.watermarkLogoUrl}">
                </td>
            </tr>
            <tr>
                <td width="15"></td>
                <td width="200">
                    <fmt:message key="ofmeet.watermark.link"/>:
                </td>
                <td>
                    <input type="text" size="60" maxlength="100" name="watermarkLink" placeholder="http://example.org" value="${admin:getProperty("org.jitsi.videobridge.ofmeet.watermark.link", "")}">
                </td>
            </tr>
            <tr><td colspan="3">&nbsp;</td></tr>
            <tr>
                <td colspan="3" nowrap>
                    <input type="checkbox" name="brandShowWatermark" ${admin:getBooleanProperty( "org.jitsi.videobridge.ofmeet.brand.show.watermark", false) ? "checked" : ""} disabled>
                    <fmt:message key="ofmeet.brand.show.watermark.enabled" />
                </td>
            </tr>
            <tr>
                <td width="15"></td>
                <td width="200">
                    <fmt:message key="ofmeet.watermark.logo.url"/>:
                </td>
                <td>
                    <input type="text" size="60" maxlength="100" name="brandWatermarkLogoUrl" value="${ofmeetConfig.brandWatermarkLogoUrl}" disabled>
                </td>
            </tr>
            <tr>
                <td width="15"></td>
                <td>
                    <fmt:message key="ofmeet.watermark.link"/>:
                </td>
                <td>
                    <input type="text" size="60" maxlength="100" name="brandWatermarkLink" value="${admin:getProperty("org.jitsi.videobridge.ofmeet.brand.watermark.link", "")}" disabled>
                </td>
            </tr>
        </table>
    </admin:contentBox>


    <input type="hidden" name="csrf" value="${csrf}">

    <input type="submit" name="update" value="<fmt:message key="global.save_settings" />">

</form>
</body>
</html>
