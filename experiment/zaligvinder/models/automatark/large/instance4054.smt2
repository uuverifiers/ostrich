(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; (NL-?)?[0-9]{9}B[0-9]{2}
(assert (str.in_re X (re.++ (re.opt (re.++ (str.to_re "NL") (re.opt (str.to_re "-")))) ((_ re.loop 9 9) (re.range "0" "9")) (str.to_re "B") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "\u{0a}"))))
; /<rt[^?]*?style\s*=\s*[\u{22}\u{27}]?-ms-hyphens\s*\x3A\s*auto\s*\x3B\s*[\u{27}\u{22}]?\>[\w\W]{680}/smi
(assert (str.in_re X (re.++ (str.to_re "/<rt") (re.* (re.comp (str.to_re "?"))) (str.to_re "style") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "-ms-hyphens") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ":") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "auto") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re ";") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "'") (str.to_re "\u{22}"))) (str.to_re ">") ((_ re.loop 680 680) (re.union (re.comp (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "/smi\u{0a}"))))
; /filename=[^\n]*\u{2e}dvr-ms/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".dvr-ms/i\u{0a}")))))
(check-sat)
