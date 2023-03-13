(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /\/[a-z]+\?[a-z]+\=[a-z]+$/U
(assert (not (str.in_re X (re.++ (str.to_re "//") (re.+ (re.range "a" "z")) (str.to_re "?") (re.+ (re.range "a" "z")) (str.to_re "=") (re.+ (re.range "a" "z")) (str.to_re "/U\u{0a}")))))
; /xsl\x3Atemplate[^\x3E]*priority\s*\x3D[\s\u{22}\u{27}]*[\d\x2D]*[^\s\u{22}\u{27}\d\u{2d}]/smi
(assert (str.in_re X (re.++ (str.to_re "/xsl:template") (re.* (re.comp (str.to_re ">"))) (str.to_re "priority") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "=") (re.* (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* (re.union (re.range "0" "9") (str.to_re "-"))) (re.union (str.to_re "\u{22}") (str.to_re "'") (re.range "0" "9") (str.to_re "-") (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "/smi\u{0a}"))))
; /Content-Disposition\u{3a}\u{20}inline\u{3b}[^\u{0d}\u{0a}]filename=[a-z]{5,8}\d{2,3}\.pdf\u{0d}\u{0a}/Hm
(assert (str.in_re X (re.++ (str.to_re "/Content-Disposition: inline;") (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}")) (str.to_re "filename=") ((_ re.loop 5 8) (re.range "a" "z")) ((_ re.loop 2 3) (re.range "0" "9")) (str.to_re ".pdf\u{0d}\u{0a}/Hm\u{0a}"))))
(check-sat)
