(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^sleep\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/sleep|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
; PASSW=\s+\x2Fta\x2FNEWS\x2F.*loomcompany\x2Ecom
(assert (not (str.in_re X (re.++ (str.to_re "PASSW=") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "/ta/NEWS/") (re.* re.allchar) (str.to_re "loomcompany.com\u{0a}")))))
; ^((l((ll)|(b)|(bb)|(bbb)))|(bb*))$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "l") (re.union (str.to_re "ll") (str.to_re "b") (str.to_re "bb") (str.to_re "bbb"))) (re.++ (str.to_re "b") (re.* (str.to_re "b")))) (str.to_re "\u{0a}")))))
; search2\.ad\.shopnav\.com\x2F9899\x2Fsearch\x2Fresults\.php.*Logger.*Subject\u{3a}\s+Host\x3AHost\x3A
(assert (str.in_re X (re.++ (str.to_re "search2.ad.shopnav.com/9899/search/results.php") (re.* re.allchar) (str.to_re "Logger") (re.* re.allchar) (str.to_re "Subject:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:\u{0a}"))))
(check-sat)
