(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(\{1}[2-9]{1}[0-9]{2}\){1}[ ]?[2-9]{1}[0-9]{2}(-| )?[0-9]{4}|[2-9]{1}[0-9]{2}[ ]{1}[2-9]{1}[0-9]{2}[ ]{1}[0-9]{4}|[2-9]{1}[0-9]{2}[2-9]{1}[0-9]{6}|[2-9]{1}[0-9]{2}-{1}[2-9]{1}[0-9]{2}-{1}[0-9]{4}){1}$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.++ (str.to_re "{1}") ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re ")")) (re.opt (str.to_re " ")) ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " "))) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re " ")) ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 6 6) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "-")) ((_ re.loop 1 1) (re.range "2" "9")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (str.to_re "-")) ((_ re.loop 4 4) (re.range "0" "9"))))) (str.to_re "\u{0a}"))))
; \\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}
(assert (not (str.in_re X (re.++ (str.to_re "\u{5c}") ((_ re.loop 1 3) (str.to_re "d")) (str.to_re "\u{5c}") re.allchar (str.to_re "\u{5c}") ((_ re.loop 1 3) (str.to_re "d")) (str.to_re "\u{5c}") re.allchar (str.to_re "\u{5c}") ((_ re.loop 1 3) (str.to_re "d")) (str.to_re "\u{5c}") re.allchar (str.to_re "\u{5c}") ((_ re.loop 1 3) (str.to_re "d")) (str.to_re "\u{0a}")))))
; ProjectMyWebSearchSearchAssistantfast-look\x2EcomOneReporter
(assert (str.in_re X (str.to_re "ProjectMyWebSearchSearchAssistantfast-look.comOneReporter\u{0a}")))
; ^\d$|^[1][0]$
(assert (str.in_re X (re.union (re.range "0" "9") (str.to_re "10\u{0a}"))))
(check-sat)
