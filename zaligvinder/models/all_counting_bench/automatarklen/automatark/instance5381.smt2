(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /^User\u{2d}Agent\u{3a}\s*[^\n]*Safari[^\n]*\r\n/smi
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re "Safari") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re "\u{0d}\u{0a}/smi\u{0a}")))))
; this\w+c\.goclick\.com\d
(assert (not (str.in_re X (re.++ (str.to_re "this") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "c.goclick.com") (re.range "0" "9") (str.to_re "\u{0a}")))))
; /^dataget\u{7c}\d+\u{7c}\d+\x7C[a-z0-9]+\x2E[a-z]{2,3}\x7C[a-z0-9]+\x7C/
(assert (str.in_re X (re.++ (str.to_re "/dataget|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.range "0" "9")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re ".") ((_ re.loop 2 3) (re.range "a" "z")) (str.to_re "|") (re.+ (re.union (re.range "a" "z") (re.range "0" "9"))) (str.to_re "|/\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
