(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; [0-9.\-/+() ]{4,}
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") ((_ re.loop 4 4) (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " "))) (re.* (re.union (re.range "0" "9") (str.to_re ".") (str.to_re "-") (str.to_re "/") (str.to_re "+") (str.to_re "(") (str.to_re ")") (str.to_re " "))))))
; /\u{2e}ppt([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.ppt") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
; ^([A-Z]|[a-z]|[0-9])([A-Z]|[a-z]|[0-9]|([A-Z]|[a-z]|[0-9]|(%|&|'|\+|\-|@|_|\.|\ )[^%&'\+\-@_\.\ ]|\.$|([%&'\+\-@_\.]\ [^\ ]|\ [%&'\+\-@_\.][^%&'\+\-@_\.])))+$
(assert (not (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.+ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9") (re.++ (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".") (str.to_re " ")) (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".") (str.to_re " "))) (str.to_re ".") (re.++ (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".")) (str.to_re " ") (re.comp (str.to_re " "))) (re.++ (str.to_re " ") (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re ".")) (re.union (str.to_re "%") (str.to_re "&") (str.to_re "'") (str.to_re "+") (str.to_re "-") (str.to_re "@") (str.to_re "_") (str.to_re "."))))) (str.to_re "\u{0a}")))))
; A + B
(assert (not (str.in_re X (re.++ (str.to_re "A") (re.+ (str.to_re " ")) (str.to_re " B\u{0a}")))))
; @"^\d[a-zA-Z]\w{1}\d{2}[a-zA-Z]\w{1}\d{3}$"
(assert (str.in_re X (re.++ (str.to_re "@\u{22}") (re.range "0" "9") (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 2 2) (re.range "0" "9")) (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 1 1) (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{22}\u{0a}"))))
(check-sat)
