(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}ram/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ram/i\u{0a}")))))
; Subject\x3A.*User-Agent\x3A.*ResultATTENTION\x3A
(assert (not (str.in_re X (re.++ (str.to_re "Subject:") (re.* re.allchar) (str.to_re "User-Agent:") (re.* re.allchar) (str.to_re "ResultATTENTION:\u{0a}")))))
; \u{22}StarLogger\u{22}User-Agent\x3AJMailUser-Agent\x3A
(assert (not (str.in_re X (str.to_re "\u{22}StarLogger\u{22}User-Agent:JMailUser-Agent:\u{0a}"))))
; [\\""=/>](25[0-4]|2[0-4][0-9]|1\d{2}|\d{2})\.((25[0-4]|2[0-4][0-9]|1\d{2}|\d{1,2})\.){2}(25[0-4]|2[0-4][0-9]|1\d{2}|\d{2}|[1-9])\b[\\""=:;,/<]
(assert (str.in_re X (re.++ (re.union (str.to_re "\u{5c}") (str.to_re "\u{22}") (str.to_re "=") (str.to_re "/") (str.to_re ">")) (re.union (re.++ (str.to_re "25") (re.range "0" "4")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 2) (re.++ (re.union (re.++ (str.to_re "25") (re.range "0" "4")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 1 2) (re.range "0" "9"))) (str.to_re "."))) (re.union (re.++ (str.to_re "25") (re.range "0" "4")) (re.++ (str.to_re "2") (re.range "0" "4") (re.range "0" "9")) (re.++ (str.to_re "1") ((_ re.loop 2 2) (re.range "0" "9"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.range "1" "9")) (re.union (str.to_re "\u{5c}") (str.to_re "\u{22}") (str.to_re "=") (str.to_re ":") (str.to_re ";") (str.to_re ",") (str.to_re "/") (str.to_re "<")) (str.to_re "\u{0a}"))))
(check-sat)
