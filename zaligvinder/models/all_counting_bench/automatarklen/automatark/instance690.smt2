(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ((^([\d]{1,3})(,{1}([\d]{3}))*)|(^[\d]*))((\.{1}[\d]{2})?$)
(assert (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.* (re.++ ((_ re.loop 1 1) (str.to_re ",")) ((_ re.loop 3 3) (re.range "0" "9"))))) (re.* (re.range "0" "9"))) (re.opt (re.++ ((_ re.loop 1 1) (str.to_re ".")) ((_ re.loop 2 2) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; www\x2Ezhongsou\x2Ecom\w+FTX-Mailer\x3A
(assert (not (str.in_re X (re.++ (str.to_re "www.zhongsou.com") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "FTX-Mailer:\u{13}\u{0a}")))))
; track\s+community\d+4\u{2e}8\u{2e}4www\x2Emaxifiles\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "track") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "community") (re.+ (re.range "0" "9")) (str.to_re "4.8.4www.maxifiles.com\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
