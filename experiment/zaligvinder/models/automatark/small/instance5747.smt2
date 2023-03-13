(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/b\/(letr|req|opt|eve)\/[0-9a-fA-F]{24}$/U
(assert (str.in_re X (re.++ (str.to_re "//b/") (re.union (str.to_re "letr") (str.to_re "req") (str.to_re "opt") (str.to_re "eve")) (str.to_re "/") ((_ re.loop 24 24) (re.union (re.range "0" "9") (re.range "a" "f") (re.range "A" "F"))) (str.to_re "/U\u{0a}"))))
; ([0-9]+:)?[0-9]+\s*(am|pm)|[0-9]+:[0-9]+\s*(am|pm)?
(assert (str.in_re X (re.union (re.++ (re.opt (re.++ (re.+ (re.range "0" "9")) (str.to_re ":"))) (re.+ (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (str.to_re "am") (str.to_re "pm"))) (re.++ (re.+ (re.range "0" "9")) (str.to_re ":") (re.+ (re.range "0" "9")) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "am") (str.to_re "pm"))) (str.to_re "\u{0a}")))))
; ^([A-Z]|[a-z]|[0-9])(([A-Z])*(([a-z])*([0-9])*(%)*(&)*(')*(\+)*(-)*(@)*(_)*(\.)*)|(\ )[^  ])+$
(assert (str.in_re X (re.++ (re.union (re.range "A" "Z") (re.range "a" "z") (re.range "0" "9")) (re.+ (re.union (re.++ (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "0" "9")) (re.* (str.to_re "%")) (re.* (str.to_re "&")) (re.* (str.to_re "'")) (re.* (str.to_re "+")) (re.* (str.to_re "-")) (re.* (str.to_re "@")) (re.* (str.to_re "_")) (re.* (str.to_re "."))) (re.++ (str.to_re " ") (re.comp (str.to_re " "))))) (str.to_re "\u{0a}"))))
(check-sat)
