(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ToolbarUser-Agent\x3AFrom\x3A
(assert (str.in_re X (str.to_re "ToolbarUser-Agent:From:\u{0a}")))
; ^([A-Z\d]{3})[A-Z]{2}\d{2}([A-Z\d]{1})([X\d]{1})([A-Z\d]{3})\d{5}$
(assert (str.in_re X (re.++ ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "A" "Z")) ((_ re.loop 2 2) (re.range "0" "9")) ((_ re.loop 1 1) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 1 1) (re.union (str.to_re "X") (re.range "0" "9"))) ((_ re.loop 3 3) (re.union (re.range "A" "Z") (re.range "0" "9"))) ((_ re.loop 5 5) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; (script)|(<)|(>)|(%3c)|(%3e)|(SELECT) |(UPDATE) |(INSERT) |(DELETE)|(GRANT) |(REVOKE)|(UNION)|(&lt;)|(&gt;)
(assert (str.in_re X (re.union (str.to_re "script") (str.to_re "<") (str.to_re ">") (str.to_re "%3c") (str.to_re "%3e") (str.to_re "SELECT ") (str.to_re "UPDATE ") (str.to_re "INSERT ") (str.to_re "DELETE") (str.to_re "GRANT ") (str.to_re "REVOKE") (str.to_re "UNION") (str.to_re "&lt;") (str.to_re "&gt;\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
