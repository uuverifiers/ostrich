(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (([0-2]{1}[0-9]{1})|([3-3]{1}[0-1]))/[1-12]{2}/[1900-2999]{4}\s(([0-0]{1}[0-9]{1})|([1-1]{1}[0-9]{1})|([2-2]{1}[0-3]{1})):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "3" "3")) (re.range "0" "1"))) (str.to_re "/") ((_ re.loop 2 2) (re.union (re.range "1" "1") (str.to_re "2"))) (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "1") (str.to_re "9") (str.to_re "0") (re.range "0" "2"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "0")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "2" "2")) ((_ re.loop 1 1) (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; ^0?[0-9]?[0-9]$|^(100)$
(assert (not (str.in_re X (re.union (re.++ (re.opt (str.to_re "0")) (re.opt (re.range "0" "9")) (re.range "0" "9")) (str.to_re "100\u{0a}")))))
; ^((http:\/\/www\.)|(www\.)|(http:\/\/))[a-zA-Z0-9._-]+\.[a-zA-Z.]{2,5}$
(assert (not (str.in_re X (re.++ (re.union (str.to_re "http://www.") (str.to_re "www.") (str.to_re "http://")) (re.+ (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9") (str.to_re ".") (str.to_re "_") (str.to_re "-"))) (str.to_re ".") ((_ re.loop 2 5) (re.union (re.range "a" "z") (re.range "A" "Z") (str.to_re "."))) (str.to_re "\u{0a}")))))
; Host\u{3a}\w+Host\x3A[^\n\r]*Host\x3AHost\u{3a}\x5Chome\/lordofsearch
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:\u{5c}home/lordofsearch\u{0a}"))))
; http://(www\.)?([^\.]+)\.com
(assert (str.in_re X (re.++ (str.to_re "http://") (re.opt (str.to_re "www.")) (re.+ (re.comp (str.to_re "."))) (str.to_re ".com\u{0a}"))))
(check-sat)
