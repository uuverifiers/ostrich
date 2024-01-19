(set-logic QF_SLIA)
(set-option :produce-models true)
(declare-const X String)
; /filename=[^\n]*\u{2e}mpeg/i
(assert (not (str.in_re X (re.++ (str.to_re "/filename=") (re.* (re.comp (str.to_re "\u{0a}"))) (str.to_re ".mpeg/i\u{0a}")))))
; ^[1-9]{1}[0-9]{0,2}([\.\,]?[0-9]{3})*$
(assert (str.in_re X (re.++ ((_ re.loop 1 1) (re.range "1" "9")) ((_ re.loop 0 2) (re.range "0" "9")) (re.* (re.++ (re.opt (re.union (str.to_re ".") (str.to_re ","))) ((_ re.loop 3 3) (re.range "0" "9")))) (str.to_re "\u{0a}"))))
; /\u{00}{7}\u{55}\u{00}{3}\u{21}.{4}[^\u{00}]*?[\u{22}\u{27}\u{29}\u{3b}]/
(assert (str.in_re X (re.++ (str.to_re "/") ((_ re.loop 7 7) (str.to_re "\u{00}")) (str.to_re "U") ((_ re.loop 3 3) (str.to_re "\u{00}")) (str.to_re "!") ((_ re.loop 4 4) re.allchar) (re.* (re.comp (str.to_re "\u{00}"))) (re.union (str.to_re "\u{22}") (str.to_re "'") (str.to_re ")") (str.to_re ";")) (str.to_re "/\u{0a}"))))
; ((19|20)[\d]{2}/[\d]{6}/[\d]{2})
(assert (not (str.in_re X (re.++ (str.to_re "\u{0a}") (re.union (str.to_re "19") (str.to_re "20")) ((_ re.loop 2 2) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 6 6) (re.range "0" "9")) (str.to_re "/") ((_ re.loop 2 2) (re.range "0" "9"))))))
; ^[[V|E|J|G]\d\d\d\d\d\d\d\d]{0,9}$
(assert (str.in_re X (re.++ (re.union (str.to_re "[") (str.to_re "V") (str.to_re "|") (str.to_re "E") (str.to_re "J") (str.to_re "G")) (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") (re.range "0" "9") ((_ re.loop 0 9) (str.to_re "]")) (str.to_re "\u{0a}"))))
(assert (> (str.len X) 10))
(check-sat)
