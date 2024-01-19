(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; ^(6553[0-5]|655[0-2]\d|65[0-4]\d\d|6[0-4]\d{3}|5\d{4}|49[2-9]\d\d|491[6-9]\d|4915[2-9])$
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "6553") (re.range "0" "5")) (re.++ (str.to_re "655") (re.range "0" "2") (re.range "0" "9")) (re.++ (str.to_re "65") (re.range "0" "4") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "6") (re.range "0" "4") ((_ re.loop 3 3) (re.range "0" "9"))) (re.++ (str.to_re "5") ((_ re.loop 4 4) (re.range "0" "9"))) (re.++ (str.to_re "49") (re.range "2" "9") (re.range "0" "9") (re.range "0" "9")) (re.++ (str.to_re "491") (re.range "6" "9") (re.range "0" "9")) (re.++ (str.to_re "4915") (re.range "2" "9"))) (str.to_re "\u{0a}")))))
; Host\u{3a}\w+Host\x3A[^\n\r]*Host\x3AHost\u{3a}\x5Chome\/lordofsearch
(assert (not (str.in_re X (re.++ (str.to_re "Host:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "Host:") (re.* (re.union (str.to_re "\u{0a}") (str.to_re "\u{0d}"))) (str.to_re "Host:Host:\u{5c}home/lordofsearch\u{0a}")))))
; www\x2Eweepee\x2Ecomhttp\x0D\x0ACurrentOwner\x3A
(assert (not (str.in_re X (str.to_re "www.weepee.com\u{1b}http\u{0d}\u{0a}CurrentOwner:\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
