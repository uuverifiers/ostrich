(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /Referer\u{3a}\u{20}[^\s]*\u{3a}8000\u{2f}[a-z]+\?[a-z]+=\d{6,7}\u{0d}\u{0a}/H
(assert (not (str.in_re X (re.++ (str.to_re "/Referer: ") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ":8000/") (re.+ (re.range "a" "z")) (str.to_re "?") (re.+ (re.range "a" "z")) (str.to_re "=") ((_ re.loop 6 7) (re.range "0" "9")) (str.to_re "\u{0d}\u{0a}/H\u{0a}")))))
; /\/\?[a-z0-9]{9}\=[a-zA-Z0-9]{45}/U
(assert (not (str.in_re X (re.++ (str.to_re "//?") ((_ re.loop 9 9) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "=") ((_ re.loop 45 45) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "/U\u{0a}")))))
; /filename=[^\n]*\u{2e}rjs/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rjs/i\u{0a}")))))
; ^
(assert (not (str.in_re X (str.to_re "\u{0a}"))))
; ^[a-zA-Z0-9\u{20}'\.]{8,64}[^\s]$
(assert (str.in_re X (re.++ ((_ re.loop 8 64) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re " ") (str.to_re "'") (str.to_re "."))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "\u{0a}"))))
(assert (< 200 (str.len X)))
(check-sat)
