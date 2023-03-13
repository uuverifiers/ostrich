(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /[^\u{0d}\u{0a}\u{09}\u{20}-\u{7e}]{4}/P
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re "\u{09}") (re.range " " "~"))) (str.to_re "/P\u{0a}"))))
; /\)\r\nHost\u{3a}\u{20}[a-z\d\u{2e}\u{2d}]{6,32}\r\nCache\u{2d}Control\u{3a}\u{20}no\u{2d}cache\r\n\r\n$/
(assert (not (str.in_re X (re.++ (str.to_re "/)\u{0d}\u{0a}Host: ") ((_ re.loop 6 32) (re.union (re.range "a" "z") (re.range "0" "9") (str.to_re ".") (str.to_re "-"))) (str.to_re "\u{0d}\u{0a}Cache-Control: no-cache\u{0d}\u{0a}\u{0d}\u{0a}/\u{0a}")))))
; nick_name=CIA-Test\d+url=http\x3A\d+\x2FNFO\x2CRegistered\u{28}BDLL\u{29}
(assert (str.in_re X (re.++ (str.to_re "nick_name=CIA-Test") (re.+ (re.range "0" "9")) (str.to_re "url=http:\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "/NFO,Registered(BDLL)\u{13}\u{0a}"))))
; /filename=[^\n]*\u{2e}ogv/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".ogv/i\u{0a}")))))
(check-sat)
