(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; SpyAgent\d+nick_name=CIA-Test\d+url=http\x3A\d+\x2FNFO\x2CRegistered\u{28}BDLL\u{29}
(assert (not (str.in_re X (re.++ (str.to_re "SpyAgent") (re.+ (re.range "0" "9")) (str.to_re "nick_name=CIA-Test") (re.+ (re.range "0" "9")) (str.to_re "url=http:\u{1b}") (re.+ (re.range "0" "9")) (str.to_re "/NFO,Registered(BDLL)\u{13}\u{0a}")))))
; /filename=[^\n]*\u{2e}png/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".png/i\u{0a}"))))
; ((8|\+7)-?)?\(?\d{3,5}\)?-?\d{1}-?\d{1}-?\d{1}-?\d{1}-?\d{1}((-?\d{1})?-?\d{1})?
(assert (str.in_re X (re.++ (re.opt (re.++ (re.union (str.to_re "8") (str.to_re "+7")) (re.opt (str.to_re "-")))) (re.opt (str.to_re "(")) ((_ re.loop 3 5) (re.range "0" "9")) (re.opt (str.to_re ")")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")) (re.opt (re.++ (re.opt (re.++ (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")))) (re.opt (str.to_re "-")) ((_ re.loop 1 1) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /^\/[\w-]{48}\.[a-z]{2,8}[0-9]?$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 48 48) (re.union (str.to_re "-") (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re ".") ((_ re.loop 2 8) (re.range "a" "z")) (re.opt (re.range "0" "9")) (str.to_re "/U\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
