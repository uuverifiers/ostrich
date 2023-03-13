(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /&key=[a-z0-9]{32}&dummy=\d{3,5}/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/&key=") ((_ re.loop 32 32) (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "&dummy=") ((_ re.loop 3 5) (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
; /filename=[^\n]*\u{2e}cgm/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".cgm/i\u{0a}"))))
; /[^\n -~\r]{4}/P
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0a}") (re.range " " "~") (str.to_re "\u{0d}"))) (str.to_re "/P\u{0a}")))))
; /skillName\x3D\x7B\u{28}\u{23}/Ui
(assert (str.in_re X (str.to_re "/skillName={(#/Ui\u{0a}")))
; www\x2Ericercadoppia\x2Ecom\w+TPSystem\s+User-Agent\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www.ricercadoppia.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "TPSystem") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "User-Agent:\u{0a}")))))
(check-sat)
