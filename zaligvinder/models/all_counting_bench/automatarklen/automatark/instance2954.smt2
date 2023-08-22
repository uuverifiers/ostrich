(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ProjectMyWebSearchSearchAssistantfast-look\x2EcomOneReporter
(assert (not (str.in_re X (str.to_re "ProjectMyWebSearchSearchAssistantfast-look.comOneReporter\u{0a}"))))
; /filename=[^\n]*\u{2e}fli/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".fli/i\u{0a}"))))
; Host\u{3a}[^\n\r]*pgwtjgxwthx\u{2f}byb\.xky[^\n\r]*source%3Dultrasearch136%26campaign%3Dsnap
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "pgwtjgxwthx/byb.xky") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "source%3Dultrasearch136%26campaign%3Dsnap\u{0a}")))))
; ^((((19|20)(([02468][048])|([13579][26])).02.29))|((20[0-9][0-9])|(19[0-9][0-9])).((((0[1-9])|(1[0-2])).((0[1-9])|(1[0-9])|(2[0-8])))|((((0[13578])|(1[02])).31)|(((0[1,3-9])|(1[0-2])).(29|30)))))$
(assert (str.in_re X (re.++ (re.union (re.++ (re.union (str.to_re "19") (str.to_re "20")) (re.union (re.++ (re.union (str.to_re "0") (str.to_re "2") (str.to_re "4") (str.to_re "6") (str.to_re "8")) (re.union (str.to_re "0") (str.to_re "4") (str.to_re "8"))) (re.++ (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "9")) (re.union (str.to_re "2") (str.to_re "6")))) re.allchar (str.to_re "02") re.allchar (str.to_re "29")) (re.++ (re.union (re.++ (str.to_re "20") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "19") (re.range "0" "9") (re.range "0" "9"))) re.allchar (re.union (re.++ (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) re.allchar (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "8")))) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re "3") (str.to_re "5") (str.to_re "7") (str.to_re "8"))) (re.++ (str.to_re "1") (re.union (str.to_re "0") (str.to_re "2")))) re.allchar (str.to_re "31")) (re.++ (re.union (re.++ (str.to_re "0") (re.union (str.to_re "1") (str.to_re ",") (re.range "3" "9"))) (re.++ (str.to_re "1") (re.range "0" "2"))) re.allchar (re.union (str.to_re "29") (str.to_re "30")))))) (str.to_re "\u{0a}"))))
; /\xFF\xFE\x3F\u{10}\u{00}\u{00}.{14}[\x2Bx\x2Fa-z0-9]{20}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/\u{ff}\u{fe}?\u{10}\u{00}\u{00}") ((_ re.loop 14 14) re.allchar) ((_ re.loop 20 20) (re.union (str.to_re "+") (str.to_re "x") (str.to_re "/") (re.range "a" "z") (re.range "0" "9"))) (str.to_re "/smi\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
