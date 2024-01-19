(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; \d{1,3}.?\d{0,3}\s[a-zA-Z]{2,30}\s[a-zA-Z]{2,15}
(assert (str.in_re X (re.++ ((_ re.loop 1 3) (re.range "0" "9")) (re.opt re.allchar) ((_ re.loop 0 3) (re.range "0" "9")) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 30) (re.union (re.range "a" "z") (re.range "A" "Z"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) ((_ re.loop 2 15) (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "\u{0a}"))))
; /\/m1\.exe$/U
(assert (not (str.in_re X (str.to_re "//m1.exe/U\u{0a}"))))
; (([0-2]{1}[0-9]{1})|([3-3]{1}[0-1]))/[1-12]{2}/[1900-2999]{4}\s(([0-0]{1}[0-9]{1})|([1-1]{1}[0-9]{1})|([2-2]{1}[0-3]{1})):[0-5]{1}[0-9]{1}:[0-5]{1}[0-9]{1}
(assert (not (str.in_re X (re.++ (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "2")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "3" "3")) (re.range "0" "1"))) (str.to_re "/") ((_ re.loop 2 2) (re.union (re.range "1" "1") (str.to_re "2"))) (str.to_re "/") ((_ re.loop 4 4) (re.union (str.to_re "1") (str.to_re "9") (str.to_re "0") (re.range "0" "2"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (re.union (re.++ ((_ re.loop 1 1) (re.range "0" "0")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "1" "1")) ((_ re.loop 1 1) (re.range "0" "9"))) (re.++ ((_ re.loop 1 1) (re.range "2" "2")) ((_ re.loop 1 1) (re.range "0" "3")))) (str.to_re ":") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re ":") ((_ re.loop 1 1) (re.range "0" "5")) ((_ re.loop 1 1) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; \(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\)
(assert (not (str.in_re X (re.++ (str.to_re "(") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ".") ((_ re.loop 1 3) (re.range "0" "9")) (str.to_re ")\u{0a}")))))
; /^.{27}/sR
(assert (not (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 27 27) re.allchar) (str.to_re "/sR\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
