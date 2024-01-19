(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}svg/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".svg/i\u{0a}"))))
; [0-9][0-9][0-9][0-9]-(0[1-9]|1[0-2])-(0[1-9]|1[0-9]|2[0-9]|3[0-1])\s{1}(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])
(assert (not (str.in_re X (re.++ (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "2"))) (str.to_re "-") (re.union (re.++ (str.to_re "0") (re.range "1" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "9")) (re.++ (str.to_re "3") (re.range "0" "1"))) ((_ re.loop 1 1) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.union (re.++ (str.to_re "0") (re.range "0" "9")) (re.++ (str.to_re "1") (re.range "0" "9")) (re.++ (str.to_re "2") (re.range "0" "3"))) (str.to_re ":\u{0a}") (re.range "0" "5") (re.range "0" "9")))))
; <img[^>]* src=\"([^\"]*)\"[^>]*>
(assert (not (str.in_re X (re.++ (str.to_re "<img") (re.* (re.comp (str.to_re ">"))) (str.to_re " src=\u{22}") (re.* (re.comp (str.to_re "\u{22}"))) (str.to_re "\u{22}") (re.* (re.comp (str.to_re ">"))) (str.to_re ">\u{0a}")))))
; subject\x3A.*Login\s+adfsgecoiwnf
(assert (str.in_re X (re.++ (str.to_re "subject:") (re.* re.allchar) (str.to_re "Login") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
