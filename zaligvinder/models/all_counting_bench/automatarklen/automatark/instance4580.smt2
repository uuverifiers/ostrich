(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /xsl\x3Atemplate[^\x3E]*priority\s*\x3D[\s\u{22}\u{27}]*[\d\x2D]*[^\s\u{22}\u{27}\d\u{2d}]/smi
(assert (not (str.in_re X (re.++ (str.to_re "/xsl:template") (re.* (re.comp (str.to_re ">"))) (str.to_re "priority") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.range "0" "9") (str.to_re "-"))) (re.union (str.to_re "\u{22}") (str.to_re "'") (re.range "0" "9") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/smi\u{0a}")))))
; ('.*$|Rem((\t| ).*$|$)|"(.|"")*?")
(assert (not (str.in_re X (re.++ (re.union (re.++ (str.to_re "'") (re.* re.allchar)) (re.++ (str.to_re "Rem") (re.union (str.to_re "\u{09}") (str.to_re " ")) (re.* re.allchar)) (re.++ (str.to_re "\u{22}") (re.* (re.union re.allchar (str.to_re "\u{22}\u{22}"))) (str.to_re "\u{22}"))) (str.to_re "\u{0a}")))))
; [1-2][0|9][0-9]{2}[0-1][0-9][0-3][0-9][-][0-9]{4}
(assert (str.in_re X (re.++ (re.range "1" "2") (re.union (str.to_re "0") (str.to_re "|") (str.to_re "9")) ((_ re.loop 2 2) (re.range "0" "9")) (re.range "0" "1") (re.range "0" "9") (re.range "0" "3") (re.range "0" "9") (str.to_re "-") ((_ re.loop 4 4) (re.range "0" "9")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
