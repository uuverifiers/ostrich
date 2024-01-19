(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}svg/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".svg/i\u{0a}"))))
; www\x2Emirarsearch\x2Ecom
(assert (str.in_re X (str.to_re "www.mirarsearch.com\u{0a}")))
; about\d+yxegtd\u{2f}efcwgHost\x3ATPSystemwww\x2Ee-finder\x2Ecc
(assert (str.in_re X (re.++ (str.to_re "about") (re.+ (re.range "0" "9")) (str.to_re "yxegtd/efcwgHost:TPSystemwww.e-finder.cc\u{0a}"))))
; ^(05)[0-9]{8}$
(assert (not (str.in_re X (re.++ (str.to_re "05") ((_ re.loop 8 8) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; /\u{2e}cis([\?\u{5c}\u{2f}]|$)/smiU
(assert (not (str.in_re X (re.++ (str.to_re "/.cis") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
