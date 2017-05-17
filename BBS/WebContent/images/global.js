/*
 * $RCSfile$
 * $Revision: 14166 $
 * $Date: 2005-02-07 17:57:29 -0600 (Mon, 07 Feb 2005) $
 *
 * Copyright (C) 1999-2004 Jive Software. All rights reserved.
 *
 * This software is the proprietary information of Jive Software. Use is subject to license terms.
 */

/*
 * Returns a page element by its id in a non browser specific way.
 */
function getEl(id) {
    if (document.layers) { return document.layers[id]; }
    else if (document.all) { return document.all[id]; }
    else if (document.getElementById) { return document.getElementById(id); }
}
function openWin(url) {
    var win = window.open(url,'newWindow','width=450,height=400,menubar=yes,location=no,statusbar=yes,personalbar=no,scrollbars=yes,resize=yes');
}