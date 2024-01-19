(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\u{2e}pfb([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.pfb") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^[+-]? *(\$)? *((\d+)|(\d{1,3})(\,\d{3})*)(\.\d{0,2})?$
(assert (not (str.in_re X (re.++ (re.opt (re.union (str.to_re "+") (str.to_re "-"))) (re.* (str.to_re " ")) (re.opt (str.to_re "$")) (re.* (str.to_re " ")) (re.union (re.+ (re.range "0" "9")) (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ (str.to_re ",") ((_ re.loop 3 3) (re.range "0" "9")))))) (re.opt (re.++ (str.to_re ".") ((_ re.loop 0 2) (re.range "0" "9")))) (str.to_re "\u{0a}")))))
; \[DRIVE\w+updates[^\n\r]*\u{22}StarLogger\u{22}User-Agent\x3AJMailUser-Agent\x3A
(assert (str.in_re X (re.++ (str.to_re "[DRIVE") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "updates") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}StarLogger\u{22}User-Agent:JMailUser-Agent:\u{0a}"))))
; ^[a-z0-9][a-z0-9_\.-]{0,}[a-z0-9]@[a-z0-9][a-z0-9_\.-]{0,}[a-z0-9][\.][a-z0-9]{2,4}$
(assert (not (str.in_re X (re.++ (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re "@") (re.union (re.range "a" "z") (re.range "0" "9")) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_") (str.to_re ".") (str.to_re "-"))) (re.union (re.range "a" "z") (re.range "0" "9")) (str.to_re ".") ((_ re.loop 2 4) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "\u{0a}")))))
; ^[a-z0-9_]{1}[a-z0-9\-_]*(\.[a-z0-9\-_]+)*@[a-z0-9]{1}[a-z0-9\-_]*(\.[a-z0-9\-_]+)*\.[a-z]{2,4}$
(assert (not (str.in_re X (re.++ ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "_"))) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))))) (str.to_re "@") ((_ re.loop 1 1) (re.union (re.range "a" "z") (re.range "0" "9"))) (re.* (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))) (re.* (re.++ (str.to_re ".") (re.+ (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re "-") (str.to_re "_"))))) (str.to_re ".") ((_ re.loop 2 4) (re.range "a" "z")) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
