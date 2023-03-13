(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Host\x3A\s+www\x2Eyoogee\x2Ecom
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "www.yoogee.com\u{13}\u{0a}"))))
; xpsp2-\s+spyblpat.*is\x2EphpBarFrom\x3A
(assert (str.in_re X (re.++ (str.to_re "xpsp2-") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "spyblpat") (re.* re.allchar) (str.to_re "is.phpBarFrom:\u{0a}"))))
; [0-9][.][0-9]{3}$
(assert (str.in_re X (re.++ (re.range "0" "9") (str.to_re ".") ((_ re.loop 3 3) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; www\x2Ezhongsou\x2Ecomclick\x2Edotcomtoolbar\x2Ecom
(assert (not (str.in_re X (str.to_re "www.zhongsou.comclick.dotcomtoolbar.com\u{0a}"))))
(check-sat)
