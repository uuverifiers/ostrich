(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /tip\x3D[a-zA-Z]+\u{26}cli\x3D[a-zA-Z]+\u{26}tipo\x3Dcli\u{26}inf\x3D/smiP
(assert (not (str.in_re X (re.++ (str.to_re "/tip=") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "&cli=") (re.+ (re.union (re.range "a" "z") (re.range "A" "Z"))) (str.to_re "&tipo=cli&inf=/smiP\u{0a}")))))
; (/\*[\d\D]*?\*/)|(\/\*(\s*|.*?)*\*\/)|(\/\/.*)|(/\\*[\\d\\D]*?\\*/)|([\r\n ]*//[^\r\n]*)+
(assert (not (str.in_re X (re.union (re.++ (str.to_re "/*") (re.* (re.union (re.range "0" "9") (re.comp (re.range "0" "9")))) (str.to_re "*/")) (re.++ (str.to_re "/*") (re.* (re.union (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (re.* re.allchar))) (str.to_re "*/")) (re.++ (str.to_re "//") (re.* re.allchar)) (re.++ (str.to_re "/") (re.* (str.to_re "\u{5c}")) (re.* (re.union (str.to_re "\u{5c}") (str.to_re "d") (str.to_re "D"))) (re.* (str.to_re "\u{5c}")) (str.to_re "/")) (re.++ (re.+ (re.++ (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}") (str.to_re " "))) (str.to_re "//") (re.* (re.union (str.to_re "\u{0d}") (str.to_re "\u{0a}"))))) (str.to_re "\u{0a}"))))))
; 62[0-9]{14,17}
(assert (not (str.in_re X (re.++ (str.to_re "62") ((_ re.loop 14 17) (re.range "0" "9")) (str.to_re "\u{0a}")))))
; www\x2Ewebcruiser\x2EccJMailBoxHostGENERAL_PARAM2FT
(assert (not (str.in_re X (str.to_re "www.webcruiser.ccJMailBoxHostGENERAL_PARAM2FT\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
