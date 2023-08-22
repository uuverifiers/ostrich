(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(0)44[\s]{0,1}[\-]{0,1}[\s]{0,1}2[\s]{0,1}[1-9]{1}[0-9]{6}$
(assert (str.in_re X (re.++ (str.to_re "044") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (str.to_re "-")) (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "2") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; ^[+-]?[0-9]+$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.+ (re.range "0" "9")) (str.to_re "\u{0a}")))))
; zmnjgmomgbdz\u{2f}zzmw\.gzt\d+Ready
(assert (not (str.in_re X (re.++ (str.to_re "zmnjgmomgbdz/zzmw.gzt") (re.+ (re.range "0" "9")) (str.to_re "Ready\u{0a}")))))
; are\d+X-Mailer\u{3a}+\d+v=User-Agent\u{3a}
(assert (str.in_re X (re.++ (str.to_re "are") (re.+ (re.range "0" "9")) (str.to_re "X-Mailer") (re.+ (str.to_re ":")) (re.+ (re.range "0" "9")) (str.to_re "v=User-Agent:\u{0a}"))))
; (script)|(<)|(>)|(%3c)|(%3e)|(SELECT) |(UPDATE) |(INSERT) |(DELETE)|(GRANT) |(REVOKE)|(UNION)|(&lt;)|(&gt;)
(assert (not (str.in_re X (re.union (str.to_re "script") (str.to_re "<") (str.to_re ">") (str.to_re "%3c") (str.to_re "%3e") (str.to_re "SELECT ") (str.to_re "UPDATE ") (str.to_re "INSERT ") (str.to_re "DELETE") (str.to_re "GRANT ") (str.to_re "REVOKE") (str.to_re "UNION") (str.to_re "&lt;") (str.to_re "&gt;\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
