(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /onload\s*\x3D\s*[\u{22}\u{27}]?location\.reload\s*\u{28}/smi
(assert (not (str.in_re X (re.++ (str.to_re "/onload") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.opt (re.union (str.to_re "\u{22}") (str.to_re "'"))) (str.to_re "location.reload") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "(/smi\u{0a}")))))
; /stat2\.php\?w=\d+\u{26}i=[0-9a-f]{32}\u{26}a=\d+/Ui
(assert (not (str.in_re X (re.++ (str.to_re "/stat2.php?w=") (re.+ (re.range "0" "9")) (str.to_re "&i=") ((_ re.loop 32 32) (re.union (re.range "0" "9") (re.range "a" "f"))) (str.to_re "&a=") (re.+ (re.range "0" "9")) (str.to_re "/Ui\u{0a}")))))
(check-sat)
