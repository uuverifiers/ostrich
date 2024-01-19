(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Pleasetvshowticketsmedia\x2Edxcdirect\x2Ecom\x2Fbar_pl\x2Fchk\.fcgi
(assert (not (str.in_re X (str.to_re "Pleasetvshowticketsmedia.dxcdirect.com/bar_pl/chk.fcgi\u{0a}"))))
; /\/jdb\/inf\.php\?id=[a-f0-9]{32}$/Ui
(assert (not (str.in_re X (re.++ (str.to_re "//jdb/inf.php?id=") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/Ui\u{0a}")))))
; ^\$?(([1-9],)?([0-9]{3},){0,3}[0-9]{3}|[0-9]{0,16})(\.[0-9]{0,3})?$
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "$")) (re.union (re.++ (re.opt (re.++ (re.range "1" "9") (str.to_re ","))) ((_ re.loop 0 3) (re.++ ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9"))) ((_ re.loop 0 16) (re.range "0" "9"))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 3) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; Host\x3Abacktrust\x2EcomconfigINTERNAL\.iniTrojanCurrentDaemonresultsmaster\x2EcomReportMyuntil
(assert (not (str.in_re X (str.to_re "Host:backtrust.comconfigINTERNAL.iniTrojanCurrentDaemonresultsmaster.com\u{13}ReportMyuntil\u{0a}"))))
; /filename=[^\n]*\u{2e}avi/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".avi/i\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
