(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /User-Agent\x3A\s+?mus[\u{0d}\u{0a}]/iH
(assert (not (str.in_re X (re.++ (str.to_re "/User-Agent:") (re.+ (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "mus") (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "/iH\u{0a}")))))
; /filename=[^\n]*\u{2e}xslt/i
(assert (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".xslt/i\u{0a}"))))
; \d+([\.|\,][0]+?[1-9]+)?
(assert (str.in_re X (re.++ (re.+ (re.range "0" "9")) (re.opt (re.++ (re.union (str.to_re ".") (str.to_re "|") (str.to_re ",")) (re.+ (str.to_re "0")) (re.+ (re.range "1" "9")))) (str.to_re "\u{0a}"))))
; (^(6334)[5-9](\d{11}$|\d{13,14}$))
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}6334") (re.range "5" "9") (re.union ((_ re.loop 11 11) (re.range "0" "9")) ((_ re.loop 13 14) (re.range "0" "9")))))))
(check-sat)
