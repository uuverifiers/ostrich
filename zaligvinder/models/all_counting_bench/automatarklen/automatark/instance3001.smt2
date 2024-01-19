(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Ewebcruiser\x2Eccgot
(assert (not (str.in_re X (str.to_re "www.webcruiser.ccgot\u{0a}"))))
; ^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})(\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9]{1,2})){3}$
(assert (str.in_re X (re.++ (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) ((_ re.loop 1 2) (re.range "0" "9"))) ((_ re.loop 3 3) (re.++ (str.to_re ".") (re.union (re.++ (str.to_re "25") (re.range "0" "5")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9") (re.range "0" "9")) ((_ re.loop 1 2) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; stats\u{2e}drivecleaner\u{2e}com\sPARSERInformationurl=Host\x3A
(assert (str.in_re X (re.++ (str.to_re "stats.drivecleaner.com\u{13}") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "PARSERInformationurl=Host:\u{0a}"))))
; ^\d{1,7}$
(assert (str.in_re X (re.++ ((_ re.loop 1 7) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
