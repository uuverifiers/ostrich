(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^\/[A-Z]{6}$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 6 6) (re.range "A" "Z")) (str.to_re "/U\u{0a}")))))
; Host\x3A\ssource%3Dultrasearch136%26campaign%3Dsnap
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "source%3Dultrasearch136%26campaign%3Dsnap\u{0a}")))))
; ^\s*[a-zA-Z0-9,&\s]+\s*$
(assert (str.in_re X (re.++ (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ",") (str.to_re "&") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}aom/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".aom/i\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
