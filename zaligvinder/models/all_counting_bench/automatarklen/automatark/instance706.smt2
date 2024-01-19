(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}tga/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".tga/i\u{0a}")))))
; PASSW=\w+www2\u{2e}instantbuzz\u{2e}com\s+Online
(assert (not (str.in_re X (re.++ (str.to_re "PASSW=") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "www2.instantbuzz.com") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Online\u{0a}")))))
; /#([1-9]){2}([1-9]){2}([1-9]){2}/
(assert (str.in_re X (re.++ (str.to_re "/#") ((_ re.loop 2 2) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "1" "9")) ((_ re.loop 2 2) (re.range "1" "9")) (str.to_re "/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
