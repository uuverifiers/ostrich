(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; www\x2Ezhongsou\x2Ecomclick\x2Edotcomtoolbar\x2Ecom
(assert (not (str.in_re X (str.to_re "www.zhongsou.comclick.dotcomtoolbar.com\u{0a}"))))
; User-Agent\x3A\w+Owner\x3A\w+Wordixqshv\u{2f}qzccsServer\u{00}MyBYReferer\x3Awww\x2Eccnnlc\x2Ecom\u{04}\u{00}
(assert (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Owner:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Wordixqshv/qzccsServer\u{00}MyBYReferer:www.ccnnlc.com\u{13}\u{04}\u{00}\u{0a}"))))
; /\/[a-f0-9]{32}\/[a-f0-9]{32}\u{22}/R
(assert (not (str.in_re X (re.++ (str.to_re "//") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "/") ((_ re.loop 32 32) (re.union (re.range "a" "f") (re.range "0" "9"))) (str.to_re "\u{22}/R\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
