(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \x2Ehtml\s+IDENTIFYwww\x2Eccnnlc\x2Ecomfilename=\u{22}Referer\x3A
(assert (not (str.in_re X (re.++ (str.to_re ".html") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "IDENTIFYwww.ccnnlc.com\u{13}filename=\u{22}Referer:\u{0a}")))))
; ^\d*((\.\d+)?)*$
(assert (not (str.in_re X (re.++ (re.* (re.range "0" "9")) (re.* (re.opt (re.++ (str.to_re ".") (re.+ (re.range "0" "9"))))) (str.to_re "\u{0a}")))))
; ^((http:\/\/www\.)|(www\.)|(http:\/\/))[a-zA-Z0-9._-]+\.[a-zA-Z.]{2,5}$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "http://www.") (str.to_re "www.") (str.to_re "http://")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "."))) (str.to_re "\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
