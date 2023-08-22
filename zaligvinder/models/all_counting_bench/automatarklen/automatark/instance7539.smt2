(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^([a-zA-Z0-9]{6,18}?)$
(assert (str.in_re X (re.++ ((_ re.loop 6 18) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (str.to_re "\u{0a}"))))
; /filename=[^\n]*\u{2e}dbp/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dbp/i\u{0a}"))))
; \d+,?\d+\$?
(assert (not (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (str.to_re ",")) (re.+ (re.range "0" "9")) (re.opt (str.to_re "$")) (str.to_re "\u{0a}")))))
; nick_name=CIA-Test\d+url=http\x3A\d+\x2FNFO\x2CRegistered\u{28}BDLL\u{29}
(assert (not (str.in_re X (re.++ (str.to_re "nick_name=CIA-Test") (re.+ (re.range "0" "9")) (str.to_re "url=http:\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "/NFO,Registered(BDLL)\u{13}\u{0a}")))))
; at\w+Pre\s+adfsgecoiwnfhirmvtg\u{2f}ggqh\.kqhSurveillanceHost\x3A
(assert (str.in_re X (re.++ (str.to_re "at") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Pre") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "adfsgecoiwnf\u{1b}hirmvtg/ggqh.kqh\u{1b}Surveillance\u{13}Host:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
