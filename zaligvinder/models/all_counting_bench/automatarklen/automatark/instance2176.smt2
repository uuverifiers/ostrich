(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (1[8,9]|20)[0-9]{2}
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "1") (re.union (str.to_re "8") (str.to_re ",") (str.to_re "9"))) (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /filename=[^\n]*\u{2e}wmf/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".wmf/i\u{0a}")))))
; Fictionaliufilfwulmfi\u{2f}riuf\.lio
(assert (not (str.in_re X (str.to_re "Fictionaliufilfwulmfi/riuf.lio\u{0a}"))))
; <!--[\d\D]*?-->
(assert (not (str.in_re X (re.++ (str.to_re "<!--") (re.* (re.union (re.range "0" "9") (re.comp (re.range "0" "9")))) (str.to_re "-->\u{0a}")))))
; ^[a-zA-Z0-9_\s-]+$
(assert (str.in_re X (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re "_") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
