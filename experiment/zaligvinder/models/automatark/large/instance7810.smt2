(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; Stablecmemailyxegtd\u{2f}efcwgUin=PromulGate
(assert (not (str.in_re X (str.to_re "Stablecmemailyxegtd/efcwgUin=PromulGate\u{0a}"))))
; \x2Fsearchfast\x2F\s+Host\x3A\s+
(assert (not (str.in_re X (re.++ (str.to_re "/searchfast/") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "Host:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{0a}")))))
; /\u{2e}cis([\?\u{5c}\u{2f}]|$)/smiU
(assert (str.in_re X (re.++ (str.to_re "/.cis") (re.union (str.to_re "?") (str.to_re "\u{5c}") (str.to_re "/")) (str.to_re "/smiU\u{0a}"))))
; ^([a-zA-Z][a-zA-Z0-9]{1,100})$
(assert (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (re.range "a" "z") (re.range "A" "Z")) ((_ re.loop 1 100) (re.union (re.range "a" "z") (re.range "A" "Z") (re.range "0" "9"))))))
; ^[A-Z]{1,2}[1-9][0-9]?[A-Z]? [0-9][A-Z]{2,}|GIR 0AA$
(assert (not (str.in_re X (re.union (re.++ ((_ re.loop 1 2) (re.range "A" "Z")) (re.range "1" "9") (re.opt (re.range "0" "9")) (re.opt (re.range "A" "Z")) (str.to_re " ") (re.range "0" "9") ((_ re.loop 2 2) (re.range "A" "Z")) (re.* (re.range "A" "Z"))) (str.to_re "GIR 0AA\u{0a}")))))
(check-sat)
