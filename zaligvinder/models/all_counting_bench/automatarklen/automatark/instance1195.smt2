(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; &[a-zA-Z]+\d{0,3};
(assert (not (str.in_re X (re.++ (str.to_re "&") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) ((_ re.loop 0 3) (re.range "0" "9")) (str.to_re ";\u{0a}")))))
; ^([A-Z]{1,}[a-z]{1,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,}[A-Z]{0,}[a-z]{0,})$
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.+ (re.range "A" "Z")) (re.+ (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z")) (re.* (re.range "A" "Z")) (re.* (re.range "a" "z"))))))
; Host\x3A.*NETObserve\d+Host\u{3a}ohgdhkzfhdzo\u{2f}uwpOK\r\n
(assert (str.in_re X (re.++ (str.to_re "Host:") (re.* re.allchar) (str.to_re "NETObserve") (re.+ (re.range "0" "9")) (str.to_re "Host:ohgdhkzfhdzo/uwpOK\u{0d}\u{0a}\u{0a}"))))
; User-Agent\x3A\w+\u{0d}\u{0a}subject=GhostVoice
(assert (not (str.in_re X (re.++ (str.to_re "User-Agent:") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{0d}\u{0a}subject=GhostVoice\u{0a}")))))
(assert (> (str.len X) 10))
(check-sat)
