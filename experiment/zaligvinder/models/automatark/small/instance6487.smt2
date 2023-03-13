(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /<script>.*?\u{2f}\u{2a}\w+\s\u{2a}\u{2f}\s*\u{22}\w+\u{22}\u{2b}\u{22}\w+\u{22}\u{2e}substr\u{28}\d{2},\d{2}\u{29}\u{2f}\u{2a}\w+\s\u{2a}\u{2f}\s\u{3b}/
(assert (not (str.in_re X (re.++ (str.to_re "/<script>") (re.* re.allchar) (str.to_re "/*") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "*/") (re.* (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}"))) (str.to_re "\u{22}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{22}+\u{22}") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (str.to_re "\u{22}.substr(") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ",") ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re ")/*") (re.+ (re.union (re.range "0" "9") (re.range "A" "Z") (re.range "a" "z") (str.to_re "_"))) (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re "*/") (re.union (str.to_re " ") (str.to_re "\u{09}") (str.to_re "\u{0a}") (str.to_re "\u{0c}") (str.to_re "\u{0d}")) (str.to_re ";/\u{0a}")))))
; /\u{2f}soft(64|32)\u{2e}dll$/U
(assert (not (str.in_re X (re.++ (str.to_re "//soft") (re.union (str.to_re "64") (str.to_re "32")) (str.to_re ".dll/U\u{0a}")))))
; .+\.([^.]+)$
(assert (not (str.in_re X (re.++ (re.+ re.allchar) (str.to_re ".") (re.+ (re.comp (str.to_re "."))) (str.to_re "\u{0a}")))))
(check-sat)
