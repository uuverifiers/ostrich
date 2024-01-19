(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; KeyloggerFSWcmdldap\x3A\x2F\x2FExploiterconnection\x2Ewww\x2Eoemji\x2Ecomzopabora\x2EinfoConnection
(assert (not (str.in_re X (str.to_re "KeyloggerFSWcmdldap://Exploiterconnection.www.oemji.comzopabora.infoConnection\u{0a}"))))
; (.|[\r\n]){1,5}
(assert (not (str.in_re X (re.++ ((_ re.loop 1 5) (re.union re.allchar (str.to_re "\u{0d}") (str.to_re "\u{0a}"))) (str.to_re "\u{0a}")))))
; Host\x3ADesktopcargo=report\<\x2Ftitle\>Host\u{3a}\.fcgiupgrade\x2Eqsrch\x2Einfo
(assert (not (str.in_re X (str.to_re "Host:Desktopcargo=report</title>Host:.fcgiupgrade.qsrch.info\u{0a}"))))
; ^(\d{3}-\d{2}-\d{4})|(\d{3}\d{2}\d{4})$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "\u{0a}") ((_ re.loop 3 3) (re.range "0" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 4 4) (re.range "0" "9")))))))
(assert (> (str.len X) 10))
(check-sat)
