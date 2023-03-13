(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Bar\x2Fnewsurfer4\x2Fclient=BysooTBADdcww\x2Edmcast\x2Ecomc\.goclick\.com
(assert (not (str.in_re X (str.to_re "Bar/newsurfer4/client=BysooTBADdcww.dmcast.comc.goclick.com\u{0a}"))))
; ^(([a-zA-Z0-9]+([\-])?[a-zA-Z0-9]+)+(\.)?)+[a-zA-Z]{2,6}$
(assert (not (str.in_re X (re.++ (re.+ (re.++ (re.+ (re.++ (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))) (re.opt (str.to_re "-")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))) (re.opt (str.to_re ".")))) ((_ re.loop 2 6) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}")))))
; ^\w*[-]*\w*\\\w*$
(assert (str.in_re X (re.++ (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.* (str.to_re "-")) (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{5c}") (re.* (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0a}"))))
(check-sat)
