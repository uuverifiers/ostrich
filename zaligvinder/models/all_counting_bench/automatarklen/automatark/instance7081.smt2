(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}rt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".rt/i\u{0a}"))))
; \d+(/\d+)?
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (str.to_re "/") (re.+ (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; Host\x3AfromZC-Bridgev\x2Exml\x2FNFO\x2CRegistered
(assert (str.in_re X (str.to_re "Host:fromZC-Bridgev.xml/NFO,Registered\u{0a}")))
; ^((([\+][\s]{0,1})|([0]{2}[\s-]{0,1}))([358]{3})([\s-]{0,1})|([0]{1}))(([1-9]{1}[0-9]{0,1})([\s-]{0,1})([0-9]{2,4})([\s-]{0,1})([0-9]{2,4})([\s-]{0,1}))([0-9]{0,3}){1}$
(assert (not (str.in_re X (re.++ (re.union (re.++ (re.union (re.++ (str.to_re "+") (re.opt (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) (re.++ ((_ re.loop 2 2) (str.to_re "0")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))))) ((_ re.loop 3 3) (re.union (str.to_re "3") (str.to_re "5") (str.to_re "8"))) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")))) ((_ re.loop 1 1) (str.to_re "0"))) ((_ re.loop 1 1) ((_ re.loop 0 3) (re.range "0" "9"))) (str.to_re "\u{0a}") (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 2 4) (re.range "0" "9")) (re.opt (re.union (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) ((_ re.loop 1 1) (re.range "1" "9")) (re.opt (re.range "0" "9"))))))
(assert (> (str.len X) 10))
(check-sat)