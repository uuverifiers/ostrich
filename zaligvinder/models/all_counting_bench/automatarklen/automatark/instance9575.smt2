(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3Abacktrust\x2EcomconfigINTERNAL\.iniTrojanCurrentDaemonresultsmaster\x2EcomReportMyuntil
(assert (not (str.in_re X (str.to_re "Host:backtrust.comconfigINTERNAL.iniTrojanCurrentDaemonresultsmaster.com\u{13}ReportMyuntil\u{0a}"))))
; User-Agent\u{3a}etbuviaebe\u{2f}eqv\.bvv
(assert (not (str.in_re X (str.to_re "User-Agent:etbuviaebe/eqv.bvv\u{0a}"))))
; ^[A-Za-z]{4}[ |\-]{0,1}[0-9]{6}[ |\-]{0,1}[0-9A-Za-z]{3}$
(assert (str.in_re X (re.++ ((_ re.loop 4 4) (re.union (re.range "A" "Z") (re.range "a" "z"))) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-"))) ((_ re.loop 6 6) (re.range "0" "9")) (re.opt (re.union (str.to_re " ") (str.to_re "|") (str.to_re "-"))) ((_ re.loop 3 3) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z"))) (str.to_re "\u{0a}"))))
; (\+)?([-\._\(\) ]?[\d]{3,20}[-\._\(\) ]?){2,10}
(assert (not (str.in_re X (re.++ (re.opt (str.to_re "+")) ((_ re.loop 2 10) (re.++ (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re " "))) ((_ re.loop 3 20) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re ".") (str.to_re "_") (str.to_re "(") (str.to_re ")") (str.to_re " "))))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
