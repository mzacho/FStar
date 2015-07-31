
let infix_prim_ops = ((Microsoft_FStar_Absyn_Const.op_Addition, "+"))::((Microsoft_FStar_Absyn_Const.op_Subtraction, "-"))::((Microsoft_FStar_Absyn_Const.op_Multiply, "*"))::((Microsoft_FStar_Absyn_Const.op_Division, "/"))::((Microsoft_FStar_Absyn_Const.op_Eq, "="))::((Microsoft_FStar_Absyn_Const.op_ColonEq, ":="))::((Microsoft_FStar_Absyn_Const.op_notEq, "<>"))::((Microsoft_FStar_Absyn_Const.op_And, "&&"))::((Microsoft_FStar_Absyn_Const.op_Or, "||"))::((Microsoft_FStar_Absyn_Const.op_LTE, "<="))::((Microsoft_FStar_Absyn_Const.op_GTE, ">="))::((Microsoft_FStar_Absyn_Const.op_LT, "<"))::((Microsoft_FStar_Absyn_Const.op_GT, ">"))::((Microsoft_FStar_Absyn_Const.op_Modulus, "mod"))::[]

let unary_prim_ops = ((Microsoft_FStar_Absyn_Const.op_Negation, "not"))::((Microsoft_FStar_Absyn_Const.op_Minus, "-"))::[]

let infix_type_ops = ((Microsoft_FStar_Absyn_Const.and_lid, "/\\"))::((Microsoft_FStar_Absyn_Const.or_lid, "\\/"))::((Microsoft_FStar_Absyn_Const.imp_lid, "==>"))::((Microsoft_FStar_Absyn_Const.iff_lid, "<==>"))::((Microsoft_FStar_Absyn_Const.precedes_lid, "<<"))::((Microsoft_FStar_Absyn_Const.eq2_lid, "=="))::((Microsoft_FStar_Absyn_Const.eqT_lid, "=="))::[]

let unary_type_ops = ((Microsoft_FStar_Absyn_Const.not_lid, "~"))::[]

let is_prim_op = (fun ( ps ) ( f ) -> (match (f.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Exp_fvar ((fv, _)) -> begin
(Support.Prims.pipe_right ps (Support.Microsoft.FStar.Util.for_some (Microsoft_FStar_Absyn_Syntax.lid_equals fv.Microsoft_FStar_Absyn_Syntax.v)))
end
| _ -> begin
false
end))

let is_type_op = (fun ( ps ) ( t ) -> (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_const (ftv) -> begin
(Support.Prims.pipe_right ps (Support.Microsoft.FStar.Util.for_some (Microsoft_FStar_Absyn_Syntax.lid_equals ftv.Microsoft_FStar_Absyn_Syntax.v)))
end
| _ -> begin
false
end))

let get_lid = (fun ( f ) -> (match (f.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Exp_fvar ((fv, _)) -> begin
fv.Microsoft_FStar_Absyn_Syntax.v
end
| _ -> begin
(failwith ("get_lid"))
end))

let get_type_lid = (fun ( t ) -> (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_const (ftv) -> begin
ftv.Microsoft_FStar_Absyn_Syntax.v
end
| _ -> begin
(failwith ("get_type_lid"))
end))

let is_infix_prim_op = (fun ( e ) -> (is_prim_op (Support.Prims.fst (Support.List.split infix_prim_ops)) e))

let is_unary_prim_op = (fun ( e ) -> (is_prim_op (Support.Prims.fst (Support.List.split unary_prim_ops)) e))

let is_infix_type_op = (fun ( t ) -> (is_type_op (Support.Prims.fst (Support.List.split infix_type_ops)) t))

let is_unary_type_op = (fun ( t ) -> (is_type_op (Support.Prims.fst (Support.List.split unary_type_ops)) t))

let quants = ((Microsoft_FStar_Absyn_Const.forall_lid, "forall"))::((Microsoft_FStar_Absyn_Const.exists_lid, "exists"))::((Microsoft_FStar_Absyn_Const.allTyp_lid, "forall"))::((Microsoft_FStar_Absyn_Const.exTyp_lid, "exists"))::[]

let is_b2t = (fun ( t ) -> (is_type_op ((Microsoft_FStar_Absyn_Const.b2t_lid)::[]) t))

let is_quant = (fun ( t ) -> (is_type_op (Support.Prims.fst (Support.List.split quants)) t))

let is_ite = (fun ( t ) -> (is_type_op ((Microsoft_FStar_Absyn_Const.ite_lid)::[]) t))

let is_lex_cons = (fun ( f ) -> (is_prim_op ((Microsoft_FStar_Absyn_Const.lexcons_lid)::[]) f))

let is_lex_top = (fun ( f ) -> (is_prim_op ((Microsoft_FStar_Absyn_Const.lextop_lid)::[]) f))

let is_inr = (fun ( _24_1 ) -> (match (_24_1) with
| Support.Microsoft.FStar.Util.Inl (_) -> begin
false
end
| Support.Microsoft.FStar.Util.Inr (_) -> begin
true
end))

let rec reconstruct_lex = (fun ( e ) -> (match ((let _68_10067 = (Microsoft_FStar_Absyn_Util.compress_exp e)
in _68_10067.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Exp_app ((f, args)) -> begin
(let args = (Support.List.filter (fun ( a ) -> (((Support.Prims.snd a) <> Some (Microsoft_FStar_Absyn_Syntax.Implicit)) && (is_inr (Support.Prims.fst a)))) args)
in (let exps = (Support.List.map (fun ( _24_2 ) -> (match (_24_2) with
| (Support.Microsoft.FStar.Util.Inl (_), _) -> begin
(failwith ("impossible"))
end
| (Support.Microsoft.FStar.Util.Inr (x), _) -> begin
x
end)) args)
in (match (((is_lex_cons f) && ((Support.List.length exps) = 2))) with
| true -> begin
(match ((let _68_10070 = (Support.List.nth exps 1)
in (reconstruct_lex _68_10070))) with
| Some (xs) -> begin
(let _68_10072 = (let _68_10071 = (Support.List.nth exps 0)
in (_68_10071)::xs)
in Some (_68_10072))
end
| None -> begin
None
end)
end
| false -> begin
None
end)))
end
| _ -> begin
(match ((is_lex_top e)) with
| true -> begin
Some ([])
end
| false -> begin
None
end)
end))

let rec find = (fun ( f ) ( l ) -> (match (l) with
| [] -> begin
(failwith ("blah"))
end
| hd::tl -> begin
(match ((f hd)) with
| true -> begin
hd
end
| false -> begin
(find f tl)
end)
end))

let find_lid = (fun ( x ) ( xs ) -> (let _68_10086 = (find (fun ( p ) -> (Microsoft_FStar_Absyn_Syntax.lid_equals x (Support.Prims.fst p))) xs)
in (Support.Prims.snd _68_10086)))

let infix_prim_op_to_string = (fun ( e ) -> (let _68_10088 = (get_lid e)
in (find_lid _68_10088 infix_prim_ops)))

let unary_prim_op_to_string = (fun ( e ) -> (let _68_10090 = (get_lid e)
in (find_lid _68_10090 unary_prim_ops)))

let infix_type_op_to_string = (fun ( t ) -> (let _68_10092 = (get_type_lid t)
in (find_lid _68_10092 infix_type_ops)))

let unary_type_op_to_string = (fun ( t ) -> (let _68_10094 = (get_type_lid t)
in (find_lid _68_10094 unary_type_ops)))

let quant_to_string = (fun ( t ) -> (let _68_10096 = (get_type_lid t)
in (find_lid _68_10096 quants)))

let rec sli = (fun ( l ) -> (match ((Support.ST.read Microsoft_FStar_Options.print_real_names)) with
| true -> begin
l.Microsoft_FStar_Absyn_Syntax.str
end
| false -> begin
l.Microsoft_FStar_Absyn_Syntax.ident.Microsoft_FStar_Absyn_Syntax.idText
end))

let strBvd = (fun ( bvd ) -> (match ((Support.ST.read Microsoft_FStar_Options.print_real_names)) with
| true -> begin
(Support.String.strcat bvd.Microsoft_FStar_Absyn_Syntax.ppname.Microsoft_FStar_Absyn_Syntax.idText bvd.Microsoft_FStar_Absyn_Syntax.realname.Microsoft_FStar_Absyn_Syntax.idText)
end
| false -> begin
(match (((Support.ST.read Microsoft_FStar_Options.hide_genident_nums) && (Support.Microsoft.FStar.Util.starts_with bvd.Microsoft_FStar_Absyn_Syntax.ppname.Microsoft_FStar_Absyn_Syntax.idText "_"))) with
| true -> begin
(Support.Prims.try_with (fun ( _24_106 ) -> (match (()) with
| () -> begin
(let _24_112 = (let _68_10101 = (Support.Microsoft.FStar.Util.substring_from bvd.Microsoft_FStar_Absyn_Syntax.ppname.Microsoft_FStar_Absyn_Syntax.idText 1)
in (Support.Microsoft.FStar.Util.int_of_string _68_10101))
in "_?")
end)) (fun ( _24_105 ) -> (match (_24_105) with
| _ -> begin
bvd.Microsoft_FStar_Absyn_Syntax.ppname.Microsoft_FStar_Absyn_Syntax.idText
end)))
end
| false -> begin
bvd.Microsoft_FStar_Absyn_Syntax.ppname.Microsoft_FStar_Absyn_Syntax.idText
end)
end))

let filter_imp = (fun ( a ) -> (Support.Prims.pipe_right a (Support.List.filter (fun ( _24_3 ) -> (match (_24_3) with
| (_, Some (Microsoft_FStar_Absyn_Syntax.Implicit)) -> begin
false
end
| _ -> begin
true
end)))))

let const_to_string = (fun ( x ) -> (match (x) with
| Microsoft_FStar_Absyn_Syntax.Const_unit -> begin
"()"
end
| Microsoft_FStar_Absyn_Syntax.Const_bool (b) -> begin
(match (b) with
| true -> begin
"true"
end
| false -> begin
"false"
end)
end
| Microsoft_FStar_Absyn_Syntax.Const_int32 (x) -> begin
(Support.Microsoft.FStar.Util.string_of_int32 x)
end
| Microsoft_FStar_Absyn_Syntax.Const_float (x) -> begin
(Support.Microsoft.FStar.Util.string_of_float x)
end
| Microsoft_FStar_Absyn_Syntax.Const_char (x) -> begin
(Support.String.strcat (Support.String.strcat "\'" (Support.Microsoft.FStar.Util.string_of_char x)) "\'")
end
| Microsoft_FStar_Absyn_Syntax.Const_string ((bytes, _)) -> begin
(Support.Microsoft.FStar.Util.format1 "\"%s\"" (Support.Microsoft.FStar.Util.string_of_bytes bytes))
end
| Microsoft_FStar_Absyn_Syntax.Const_bytearray (_) -> begin
"<bytearray>"
end
| Microsoft_FStar_Absyn_Syntax.Const_int (x) -> begin
x
end
| Microsoft_FStar_Absyn_Syntax.Const_int64 (_) -> begin
"<int64>"
end
| Microsoft_FStar_Absyn_Syntax.Const_uint8 (_) -> begin
"<uint8>"
end))

let rec tag_of_typ = (fun ( t ) -> (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_btvar (_) -> begin
"Typ_btvar"
end
| Microsoft_FStar_Absyn_Syntax.Typ_const (v) -> begin
(Support.String.strcat "Typ_const " v.Microsoft_FStar_Absyn_Syntax.v.Microsoft_FStar_Absyn_Syntax.str)
end
| Microsoft_FStar_Absyn_Syntax.Typ_fun (_) -> begin
"Typ_fun"
end
| Microsoft_FStar_Absyn_Syntax.Typ_refine (_) -> begin
"Typ_refine"
end
| Microsoft_FStar_Absyn_Syntax.Typ_app ((head, args)) -> begin
(let _68_10141 = (tag_of_typ head)
in (let _68_10140 = (Support.Prims.pipe_left Support.Microsoft.FStar.Util.string_of_int (Support.List.length args))
in (Support.Microsoft.FStar.Util.format2 "Typ_app(%s, [%s args])" _68_10141 _68_10140)))
end
| Microsoft_FStar_Absyn_Syntax.Typ_lam (_) -> begin
"Typ_lam"
end
| Microsoft_FStar_Absyn_Syntax.Typ_ascribed (_) -> begin
"Typ_ascribed"
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_pattern (_)) -> begin
"Typ_meta_pattern"
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_named (_)) -> begin
"Typ_meta_named"
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_labeled (_)) -> begin
"Typ_meta_labeled"
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_refresh_label (_)) -> begin
"Typ_meta_refresh_label"
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_slack_formula (_)) -> begin
"Typ_meta_slack_formula"
end
| Microsoft_FStar_Absyn_Syntax.Typ_uvar (_) -> begin
"Typ_uvar"
end
| Microsoft_FStar_Absyn_Syntax.Typ_delayed (_) -> begin
"Typ_delayed"
end
| Microsoft_FStar_Absyn_Syntax.Typ_unknown -> begin
"Typ_unknown"
end))
and tag_of_exp = (fun ( e ) -> (match (e.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Exp_bvar (_) -> begin
"Exp_bvar"
end
| Microsoft_FStar_Absyn_Syntax.Exp_fvar (_) -> begin
"Exp_fvar"
end
| Microsoft_FStar_Absyn_Syntax.Exp_constant (_) -> begin
"Exp_constant"
end
| Microsoft_FStar_Absyn_Syntax.Exp_abs (_) -> begin
"Exp_abs"
end
| Microsoft_FStar_Absyn_Syntax.Exp_app (_) -> begin
"Exp_app"
end
| Microsoft_FStar_Absyn_Syntax.Exp_match (_) -> begin
"Exp_match"
end
| Microsoft_FStar_Absyn_Syntax.Exp_ascribed (_) -> begin
"Exp_ascribed"
end
| Microsoft_FStar_Absyn_Syntax.Exp_let (_) -> begin
"Exp_let"
end
| Microsoft_FStar_Absyn_Syntax.Exp_uvar (_) -> begin
"Exp_uvar"
end
| Microsoft_FStar_Absyn_Syntax.Exp_delayed (_) -> begin
"Exp_delayed"
end
| Microsoft_FStar_Absyn_Syntax.Exp_meta (Microsoft_FStar_Absyn_Syntax.Meta_desugared ((_, m))) -> begin
(let _68_10142 = (meta_e_to_string m)
in (Support.String.strcat "Exp_meta_desugared " _68_10142))
end))
and meta_e_to_string = (fun ( _24_4 ) -> (match (_24_4) with
| Microsoft_FStar_Absyn_Syntax.Data_app -> begin
"Data_app"
end
| Microsoft_FStar_Absyn_Syntax.Sequence -> begin
"Sequence"
end
| Microsoft_FStar_Absyn_Syntax.Primop -> begin
"Primop"
end
| Microsoft_FStar_Absyn_Syntax.MaskedEffect -> begin
"MaskedEffect"
end))
and typ_to_string = (fun ( x ) -> (let x = (Microsoft_FStar_Absyn_Util.compress_typ x)
in (match (x.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_delayed (_) -> begin
(failwith ("impossible"))
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (Microsoft_FStar_Absyn_Syntax.Meta_named ((_, l))) -> begin
(sli l)
end
| Microsoft_FStar_Absyn_Syntax.Typ_meta (meta) -> begin
(let _68_10145 = (Support.Prims.pipe_right meta meta_to_string)
in (Support.Microsoft.FStar.Util.format1 "(Meta %s)" _68_10145))
end
| Microsoft_FStar_Absyn_Syntax.Typ_btvar (btv) -> begin
(strBvd btv.Microsoft_FStar_Absyn_Syntax.v)
end
| Microsoft_FStar_Absyn_Syntax.Typ_const (v) -> begin
(sli v.Microsoft_FStar_Absyn_Syntax.v)
end
| Microsoft_FStar_Absyn_Syntax.Typ_fun ((binders, c)) -> begin
(let _68_10147 = (binders_to_string " -> " binders)
in (let _68_10146 = (comp_typ_to_string c)
in (Support.Microsoft.FStar.Util.format2 "(%s -> %s)" _68_10147 _68_10146)))
end
| Microsoft_FStar_Absyn_Syntax.Typ_refine ((xt, f)) -> begin
(let _68_10150 = (strBvd xt.Microsoft_FStar_Absyn_Syntax.v)
in (let _68_10149 = (Support.Prims.pipe_right xt.Microsoft_FStar_Absyn_Syntax.sort typ_to_string)
in (let _68_10148 = (Support.Prims.pipe_right f formula_to_string)
in (Support.Microsoft.FStar.Util.format3 "%s:%s{%s}" _68_10150 _68_10149 _68_10148))))
end
| Microsoft_FStar_Absyn_Syntax.Typ_app ((t, args)) -> begin
(let q_to_string = (fun ( k ) ( a ) -> (match ((Support.Prims.fst a)) with
| Support.Microsoft.FStar.Util.Inl (t) -> begin
(let t = (Microsoft_FStar_Absyn_Util.compress_typ t)
in (match (t.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_lam ((b::[], t)) -> begin
(k (b, t))
end
| _ -> begin
(let _68_10161 = (tag_of_typ t)
in (let _68_10160 = (typ_to_string t)
in (Support.Microsoft.FStar.Util.format2 "<Expected a type-lambda! got %s>%s" _68_10161 _68_10160)))
end))
end
| Support.Microsoft.FStar.Util.Inr (e) -> begin
(let _68_10162 = (exp_to_string e)
in (Support.Microsoft.FStar.Util.format1 "(<Expected a type!>%s)" _68_10162))
end))
in (let qbinder_to_string = (q_to_string (fun ( x ) -> (binder_to_string (Support.Prims.fst x))))
in (let qbody_to_string = (q_to_string (fun ( x ) -> (typ_to_string (Support.Prims.snd x))))
in (let args' = (match (((Support.ST.read Microsoft_FStar_Options.print_implicits) && (not ((is_quant t))))) with
| true -> begin
args
end
| false -> begin
(Support.List.filter (fun ( _24_5 ) -> (match (_24_5) with
| (_, Some (Microsoft_FStar_Absyn_Syntax.Implicit)) -> begin
false
end
| _ -> begin
true
end)) args)
end)
in (match (((is_ite t) && ((Support.List.length args) = 3))) with
| true -> begin
(let _68_10173 = (let _68_10168 = (Support.List.nth args 0)
in (arg_to_string _68_10168))
in (let _68_10172 = (let _68_10169 = (Support.List.nth args 1)
in (arg_to_string _68_10169))
in (let _68_10171 = (let _68_10170 = (Support.List.nth args 2)
in (arg_to_string _68_10170))
in (Support.Microsoft.FStar.Util.format3 "if %s then %s else %s" _68_10173 _68_10172 _68_10171))))
end
| false -> begin
(match (((is_b2t t) && ((Support.List.length args) = 1))) with
| true -> begin
(let _68_10174 = (Support.List.nth args 0)
in (Support.Prims.pipe_right _68_10174 arg_to_string))
end
| false -> begin
(match (((is_quant t) && ((Support.List.length args) <= 2))) with
| true -> begin
(let _68_10179 = (quant_to_string t)
in (let _68_10178 = (let _68_10175 = (Support.List.nth args' 0)
in (qbinder_to_string _68_10175))
in (let _68_10177 = (let _68_10176 = (Support.List.nth args' 0)
in (qbody_to_string _68_10176))
in (Support.Microsoft.FStar.Util.format3 "(%s (%s). %s)" _68_10179 _68_10178 _68_10177))))
end
| false -> begin
(match (((is_infix_type_op t) && ((Support.List.length args') = 2))) with
| true -> begin
(let _68_10184 = (let _68_10180 = (Support.List.nth args' 0)
in (Support.Prims.pipe_right _68_10180 arg_to_string))
in (let _68_10183 = (Support.Prims.pipe_right t infix_type_op_to_string)
in (let _68_10182 = (let _68_10181 = (Support.List.nth args' 1)
in (Support.Prims.pipe_right _68_10181 arg_to_string))
in (Support.Microsoft.FStar.Util.format3 "(%s %s %s)" _68_10184 _68_10183 _68_10182))))
end
| false -> begin
(match (((is_unary_type_op t) && ((Support.List.length args') = 1))) with
| true -> begin
(let _68_10187 = (Support.Prims.pipe_right t unary_type_op_to_string)
in (let _68_10186 = (let _68_10185 = (Support.List.nth args' 0)
in (Support.Prims.pipe_right _68_10185 arg_to_string))
in (Support.Microsoft.FStar.Util.format2 "(%s %s)" _68_10187 _68_10186)))
end
| false -> begin
(let _68_10189 = (Support.Prims.pipe_right t typ_to_string)
in (let _68_10188 = (Support.Prims.pipe_right args args_to_string)
in (Support.Microsoft.FStar.Util.format2 "(%s %s)" _68_10189 _68_10188)))
end)
end)
end)
end)
end)))))
end
| Microsoft_FStar_Absyn_Syntax.Typ_lam ((binders, t2)) -> begin
(let _68_10191 = (binders_to_string " " binders)
in (let _68_10190 = (Support.Prims.pipe_right t2 typ_to_string)
in (Support.Microsoft.FStar.Util.format2 "(fun %s -> %s)" _68_10191 _68_10190)))
end
| Microsoft_FStar_Absyn_Syntax.Typ_ascribed ((t, k)) -> begin
(match ((Support.ST.read Microsoft_FStar_Options.print_real_names)) with
| true -> begin
(let _68_10193 = (typ_to_string t)
in (let _68_10192 = (kind_to_string k)
in (Support.Microsoft.FStar.Util.format2 "(%s <: %s)" _68_10193 _68_10192)))
end
| false -> begin
(Support.Prims.pipe_right t typ_to_string)
end)
end
| Microsoft_FStar_Absyn_Syntax.Typ_unknown -> begin
"<UNKNOWN>"
end
| Microsoft_FStar_Absyn_Syntax.Typ_uvar ((uv, k)) -> begin
(match ((Microsoft_FStar_Absyn_Visit.compress_typ_aux false x)) with
| {Microsoft_FStar_Absyn_Syntax.n = Microsoft_FStar_Absyn_Syntax.Typ_uvar (_); Microsoft_FStar_Absyn_Syntax.tk = _; Microsoft_FStar_Absyn_Syntax.pos = _; Microsoft_FStar_Absyn_Syntax.fvs = _; Microsoft_FStar_Absyn_Syntax.uvs = _} -> begin
(uvar_t_to_string (uv, k))
end
| t -> begin
(Support.Prims.pipe_right t typ_to_string)
end)
end)))
and uvar_t_to_string = (fun ( _24_325 ) -> (match (_24_325) with
| (uv, k) -> begin
(match ((false && (Support.ST.read Microsoft_FStar_Options.print_real_names))) with
| true -> begin
(let _68_10197 = (match ((Support.ST.read Microsoft_FStar_Options.hide_uvar_nums)) with
| true -> begin
"?"
end
| false -> begin
(let _68_10195 = (Support.Microsoft.FStar.Unionfind.uvar_id uv)
in (Support.Microsoft.FStar.Util.string_of_int _68_10195))
end)
in (let _68_10196 = (kind_to_string k)
in (Support.Microsoft.FStar.Util.format2 "(U%s : %s)" _68_10197 _68_10196)))
end
| false -> begin
(let _68_10199 = (match ((Support.ST.read Microsoft_FStar_Options.hide_uvar_nums)) with
| true -> begin
"?"
end
| false -> begin
(let _68_10198 = (Support.Microsoft.FStar.Unionfind.uvar_id uv)
in (Support.Microsoft.FStar.Util.string_of_int _68_10198))
end)
in (Support.Microsoft.FStar.Util.format1 "U%s" _68_10199))
end)
end))
and imp_to_string = (fun ( s ) ( _24_6 ) -> (match (_24_6) with
| Some (Microsoft_FStar_Absyn_Syntax.Implicit) -> begin
(Support.String.strcat "#" s)
end
| Some (Microsoft_FStar_Absyn_Syntax.Equality) -> begin
(Support.String.strcat "=" s)
end
| _ -> begin
s
end))
and binder_to_string' = (fun ( is_arrow ) ( b ) -> (match (b) with
| (Support.Microsoft.FStar.Util.Inl (a), imp) -> begin
(match (((Microsoft_FStar_Absyn_Syntax.is_null_binder b) || ((let _68_10204 = (Support.ST.read Microsoft_FStar_Options.print_real_names)
in (Support.Prims.pipe_right _68_10204 Support.Prims.op_Negation)) && (Microsoft_FStar_Absyn_Syntax.is_null_pp a.Microsoft_FStar_Absyn_Syntax.v)))) with
| true -> begin
(kind_to_string a.Microsoft_FStar_Absyn_Syntax.sort)
end
| false -> begin
(match (((not (is_arrow)) && (not ((Support.ST.read Microsoft_FStar_Options.print_implicits))))) with
| true -> begin
(let _68_10205 = (strBvd a.Microsoft_FStar_Absyn_Syntax.v)
in (imp_to_string _68_10205 imp))
end
| false -> begin
(let _68_10209 = (let _68_10208 = (let _68_10206 = (strBvd a.Microsoft_FStar_Absyn_Syntax.v)
in (Support.String.strcat _68_10206 ":"))
in (let _68_10207 = (kind_to_string a.Microsoft_FStar_Absyn_Syntax.sort)
in (Support.String.strcat _68_10208 _68_10207)))
in (imp_to_string _68_10209 imp))
end)
end)
end
| (Support.Microsoft.FStar.Util.Inr (x), imp) -> begin
(match (((Microsoft_FStar_Absyn_Syntax.is_null_binder b) || ((let _68_10210 = (Support.ST.read Microsoft_FStar_Options.print_real_names)
in (Support.Prims.pipe_right _68_10210 Support.Prims.op_Negation)) && (Microsoft_FStar_Absyn_Syntax.is_null_pp x.Microsoft_FStar_Absyn_Syntax.v)))) with
| true -> begin
(typ_to_string x.Microsoft_FStar_Absyn_Syntax.sort)
end
| false -> begin
(match (((not (is_arrow)) && (not ((Support.ST.read Microsoft_FStar_Options.print_implicits))))) with
| true -> begin
(let _68_10211 = (strBvd x.Microsoft_FStar_Absyn_Syntax.v)
in (imp_to_string _68_10211 imp))
end
| false -> begin
(let _68_10215 = (let _68_10214 = (let _68_10212 = (strBvd x.Microsoft_FStar_Absyn_Syntax.v)
in (Support.String.strcat _68_10212 ":"))
in (let _68_10213 = (typ_to_string x.Microsoft_FStar_Absyn_Syntax.sort)
in (Support.String.strcat _68_10214 _68_10213)))
in (imp_to_string _68_10215 imp))
end)
end)
end))
and binder_to_string = (fun ( b ) -> (binder_to_string' false b))
and arrow_binder_to_string = (fun ( b ) -> (binder_to_string' true b))
and binders_to_string = (fun ( sep ) ( bs ) -> (let bs = (match ((Support.ST.read Microsoft_FStar_Options.print_implicits)) with
| true -> begin
bs
end
| false -> begin
(filter_imp bs)
end)
in (match ((sep = " -> ")) with
| true -> begin
(let _68_10220 = (Support.Prims.pipe_right bs (Support.List.map arrow_binder_to_string))
in (Support.Prims.pipe_right _68_10220 (Support.String.concat sep)))
end
| false -> begin
(let _68_10221 = (Support.Prims.pipe_right bs (Support.List.map binder_to_string))
in (Support.Prims.pipe_right _68_10221 (Support.String.concat sep)))
end)))
and arg_to_string = (fun ( _24_7 ) -> (match (_24_7) with
| (Support.Microsoft.FStar.Util.Inl (a), imp) -> begin
(let _68_10223 = (typ_to_string a)
in (imp_to_string _68_10223 imp))
end
| (Support.Microsoft.FStar.Util.Inr (x), imp) -> begin
(let _68_10224 = (exp_to_string x)
in (imp_to_string _68_10224 imp))
end))
and args_to_string = (fun ( args ) -> (let args = (match ((Support.ST.read Microsoft_FStar_Options.print_implicits)) with
| true -> begin
args
end
| false -> begin
(filter_imp args)
end)
in (let _68_10226 = (Support.Prims.pipe_right args (Support.List.map arg_to_string))
in (Support.Prims.pipe_right _68_10226 (Support.String.concat " ")))))
and lcomp_typ_to_string = (fun ( lc ) -> (let _68_10229 = (sli lc.Microsoft_FStar_Absyn_Syntax.eff_name)
in (let _68_10228 = (typ_to_string lc.Microsoft_FStar_Absyn_Syntax.res_typ)
in (Support.Microsoft.FStar.Util.format2 "%s %s" _68_10229 _68_10228))))
and comp_typ_to_string = (fun ( c ) -> (match (c.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Total (t) -> begin
(let _68_10231 = (typ_to_string t)
in (Support.Microsoft.FStar.Util.format1 "Tot %s" _68_10231))
end
| Microsoft_FStar_Absyn_Syntax.Comp (c) -> begin
(let basic = (match (((Support.Prims.pipe_right c.Microsoft_FStar_Absyn_Syntax.flags (Support.Microsoft.FStar.Util.for_some (fun ( _24_8 ) -> (match (_24_8) with
| Microsoft_FStar_Absyn_Syntax.TOTAL -> begin
true
end
| _ -> begin
false
end)))) && (not ((Support.ST.read Microsoft_FStar_Options.print_effect_args))))) with
| true -> begin
(let _68_10233 = (typ_to_string c.Microsoft_FStar_Absyn_Syntax.result_typ)
in (Support.Microsoft.FStar.Util.format1 "Tot %s" _68_10233))
end
| false -> begin
(match (((not ((Support.ST.read Microsoft_FStar_Options.print_effect_args))) && (Microsoft_FStar_Absyn_Syntax.lid_equals c.Microsoft_FStar_Absyn_Syntax.effect_name Microsoft_FStar_Absyn_Const.effect_ML_lid))) with
| true -> begin
(typ_to_string c.Microsoft_FStar_Absyn_Syntax.result_typ)
end
| false -> begin
(match (((not ((Support.ST.read Microsoft_FStar_Options.print_effect_args))) && (Support.Prims.pipe_right c.Microsoft_FStar_Absyn_Syntax.flags (Support.Microsoft.FStar.Util.for_some (fun ( _24_9 ) -> (match (_24_9) with
| Microsoft_FStar_Absyn_Syntax.MLEFFECT -> begin
true
end
| _ -> begin
false
end)))))) with
| true -> begin
(let _68_10235 = (typ_to_string c.Microsoft_FStar_Absyn_Syntax.result_typ)
in (Support.Microsoft.FStar.Util.format1 "ALL %s" _68_10235))
end
| false -> begin
(match ((Support.ST.read Microsoft_FStar_Options.print_effect_args)) with
| true -> begin
(let _68_10239 = (sli c.Microsoft_FStar_Absyn_Syntax.effect_name)
in (let _68_10238 = (typ_to_string c.Microsoft_FStar_Absyn_Syntax.result_typ)
in (let _68_10237 = (let _68_10236 = (Support.Prims.pipe_right c.Microsoft_FStar_Absyn_Syntax.effect_args (Support.List.map effect_arg_to_string))
in (Support.Prims.pipe_right _68_10236 (Support.String.concat ", ")))
in (Support.Microsoft.FStar.Util.format3 "%s (%s) %s" _68_10239 _68_10238 _68_10237))))
end
| false -> begin
(let _68_10241 = (sli c.Microsoft_FStar_Absyn_Syntax.effect_name)
in (let _68_10240 = (typ_to_string c.Microsoft_FStar_Absyn_Syntax.result_typ)
in (Support.Microsoft.FStar.Util.format2 "%s (%s)" _68_10241 _68_10240)))
end)
end)
end)
end)
in (let dec = (let _68_10245 = (Support.Prims.pipe_right c.Microsoft_FStar_Absyn_Syntax.flags (Support.List.collect (fun ( _24_10 ) -> (match (_24_10) with
| Microsoft_FStar_Absyn_Syntax.DECREASES (e) -> begin
(let _68_10244 = (let _68_10243 = (exp_to_string e)
in (Support.Microsoft.FStar.Util.format1 " (decreases %s)" _68_10243))
in (_68_10244)::[])
end
| _ -> begin
[]
end))))
in (Support.Prims.pipe_right _68_10245 (Support.String.concat " ")))
in (Support.Microsoft.FStar.Util.format2 "%s%s" basic dec)))
end))
and effect_arg_to_string = (fun ( e ) -> (match (e) with
| (Support.Microsoft.FStar.Util.Inr (e), _) -> begin
(exp_to_string e)
end
| (Support.Microsoft.FStar.Util.Inl (wp), _) -> begin
(formula_to_string wp)
end))
and formula_to_string = (fun ( phi ) -> (typ_to_string phi))
and formula_to_string_old_now_unused = (fun ( phi ) -> (let const_op = (fun ( f ) ( _24_396 ) -> f)
in (let un_op = (fun ( f ) ( _24_11 ) -> (match (_24_11) with
| (Support.Microsoft.FStar.Util.Inl (t), _)::[] -> begin
(let _68_10257 = (formula_to_string t)
in (Support.Microsoft.FStar.Util.format2 "%s %s" f _68_10257))
end
| _ -> begin
(failwith ("impos"))
end))
in (let bin_top = (fun ( f ) ( _24_12 ) -> (match (_24_12) with
| (Support.Microsoft.FStar.Util.Inl (t1), _)::(Support.Microsoft.FStar.Util.Inl (t2), _)::[] -> begin
(let _68_10263 = (formula_to_string t1)
in (let _68_10262 = (formula_to_string t2)
in (Support.Microsoft.FStar.Util.format3 "%s %s %s" _68_10263 f _68_10262)))
end
| _ -> begin
(failwith ("Impos"))
end))
in (let bin_eop = (fun ( f ) ( _24_13 ) -> (match (_24_13) with
| (Support.Microsoft.FStar.Util.Inr (e1), _)::(Support.Microsoft.FStar.Util.Inr (e2), _)::[] -> begin
(let _68_10269 = (exp_to_string e1)
in (let _68_10268 = (exp_to_string e2)
in (Support.Microsoft.FStar.Util.format3 "%s %s %s" _68_10269 f _68_10268)))
end
| _ -> begin
(failwith ("impos"))
end))
in (let ite = (fun ( _24_14 ) -> (match (_24_14) with
| (Support.Microsoft.FStar.Util.Inl (t1), _)::(Support.Microsoft.FStar.Util.Inl (t2), _)::(Support.Microsoft.FStar.Util.Inl (t3), _)::[] -> begin
(let _68_10274 = (formula_to_string t1)
in (let _68_10273 = (formula_to_string t2)
in (let _68_10272 = (formula_to_string t3)
in (Support.Microsoft.FStar.Util.format3 "if %s then %s else %s" _68_10274 _68_10273 _68_10272))))
end
| _ -> begin
(failwith ("impos"))
end))
in (let eq_op = (fun ( _24_15 ) -> (match (_24_15) with
| (Support.Microsoft.FStar.Util.Inl (t1), _)::(Support.Microsoft.FStar.Util.Inl (t2), _)::(Support.Microsoft.FStar.Util.Inr (e1), _)::(Support.Microsoft.FStar.Util.Inr (e2), _)::[] -> begin
(match ((Support.ST.read Microsoft_FStar_Options.print_implicits)) with
| true -> begin
(let _68_10280 = (typ_to_string t1)
in (let _68_10279 = (typ_to_string t2)
in (let _68_10278 = (exp_to_string e1)
in (let _68_10277 = (exp_to_string e2)
in (Support.Microsoft.FStar.Util.format4 "Eq2 %s %s %s %s" _68_10280 _68_10279 _68_10278 _68_10277)))))
end
| false -> begin
(let _68_10282 = (exp_to_string e1)
in (let _68_10281 = (exp_to_string e2)
in (Support.Microsoft.FStar.Util.format2 "%s == %s" _68_10282 _68_10281)))
end)
end
| (Support.Microsoft.FStar.Util.Inr (e1), _)::(Support.Microsoft.FStar.Util.Inr (e2), _)::[] -> begin
(let _68_10284 = (exp_to_string e1)
in (let _68_10283 = (exp_to_string e2)
in (Support.Microsoft.FStar.Util.format2 "%s == %s" _68_10284 _68_10283)))
end
| _ -> begin
(failwith ("Impossible"))
end))
in (let connectives = ((Microsoft_FStar_Absyn_Const.and_lid, (bin_top "/\\")))::((Microsoft_FStar_Absyn_Const.or_lid, (bin_top "\\/")))::((Microsoft_FStar_Absyn_Const.imp_lid, (bin_top "==>")))::((Microsoft_FStar_Absyn_Const.iff_lid, (bin_top "<==>")))::((Microsoft_FStar_Absyn_Const.ite_lid, ite))::((Microsoft_FStar_Absyn_Const.not_lid, (un_op "~")))::((Microsoft_FStar_Absyn_Const.eqT_lid, (bin_top "==")))::((Microsoft_FStar_Absyn_Const.eq2_lid, eq_op))::((Microsoft_FStar_Absyn_Const.true_lid, (const_op "True")))::((Microsoft_FStar_Absyn_Const.false_lid, (const_op "False")))::[]
in (let fallback = (fun ( phi ) -> (match (phi.Microsoft_FStar_Absyn_Syntax.n) with
| Microsoft_FStar_Absyn_Syntax.Typ_lam ((binders, phi)) -> begin
(let _68_10323 = (binders_to_string " " binders)
in (let _68_10322 = (formula_to_string phi)
in (Support.Microsoft.FStar.Util.format2 "(fun %s => %s)" _68_10323 _68_10322)))
end
| _ -> begin
(typ_to_string phi)
end))
in (match ((Microsoft_FStar_Absyn_Util.destruct_typ_as_formula phi)) with
| None -> begin
(fallback phi)
end
| Some (Microsoft_FStar_Absyn_Util.BaseConn ((op, arms))) -> begin
(match ((Support.Prims.pipe_right connectives (Support.List.tryFind (fun ( _24_515 ) -> (match (_24_515) with
| (l, _) -> begin
(Microsoft_FStar_Absyn_Syntax.lid_equals op l)
end))))) with
| None -> begin
(fallback phi)
end
| Some ((_, f)) -> begin
(f arms)
end)
end
| Some (Microsoft_FStar_Absyn_Util.QAll ((vars, _, body))) -> begin
(let _68_10340 = (binders_to_string " " vars)
in (let _68_10339 = (formula_to_string body)
in (Support.Microsoft.FStar.Util.format2 "(forall %s. %s)" _68_10340 _68_10339)))
end
| Some (Microsoft_FStar_Absyn_Util.QEx ((vars, _, body))) -> begin
(let _68_10342 = (binders_to_string " " vars)
in (let _68_10341 = (formula_to_string body)
in (Support.Microsoft.FStar.Util.format2 "(exists %s. %s)" _68_10342 _68_10341)))
end))))))))))
and exp_to_string = (fun ( x ) -> (match ((let _68_10344 = (Microsoft_FStar_Absyn_Util.compress_exp x)
in _68_10344.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Exp_delayed (_) -> begin
(failwith ("Impossible"))
end
| Microsoft_FStar_Absyn_Syntax.Exp_meta (Microsoft_FStar_Absyn_Syntax.Meta_desugared ((e, _))) -> begin
(exp_to_string e)
end
| Microsoft_FStar_Absyn_Syntax.Exp_uvar ((uv, t)) -> begin
(uvar_e_to_string (uv, t))
end
| Microsoft_FStar_Absyn_Syntax.Exp_bvar (bvv) -> begin
(strBvd bvv.Microsoft_FStar_Absyn_Syntax.v)
end
| Microsoft_FStar_Absyn_Syntax.Exp_fvar ((fv, _)) -> begin
(sli fv.Microsoft_FStar_Absyn_Syntax.v)
end
| Microsoft_FStar_Absyn_Syntax.Exp_constant (c) -> begin
(Support.Prims.pipe_right c const_to_string)
end
| Microsoft_FStar_Absyn_Syntax.Exp_abs ((binders, e)) -> begin
(let _68_10346 = (binders_to_string " " binders)
in (let _68_10345 = (Support.Prims.pipe_right e exp_to_string)
in (Support.Microsoft.FStar.Util.format2 "(fun %s -> %s)" _68_10346 _68_10345)))
end
| Microsoft_FStar_Absyn_Syntax.Exp_app ((e, args)) -> begin
(let lex = (match ((Support.ST.read Microsoft_FStar_Options.print_implicits)) with
| true -> begin
None
end
| false -> begin
(reconstruct_lex x)
end)
in (match (lex) with
| Some (es) -> begin
(let _68_10349 = (let _68_10348 = (let _68_10347 = (Support.List.map exp_to_string es)
in (Support.String.concat "; " _68_10347))
in (Support.String.strcat "%[" _68_10348))
in (Support.String.strcat _68_10349 "]"))
end
| None -> begin
(let args' = (let _68_10351 = (filter_imp args)
in (Support.Prims.pipe_right _68_10351 (Support.List.filter (fun ( _24_16 ) -> (match (_24_16) with
| (Support.Microsoft.FStar.Util.Inr (_), _) -> begin
true
end
| _ -> begin
false
end)))))
in (match (((is_infix_prim_op e) && ((Support.List.length args') = 2))) with
| true -> begin
(let _68_10356 = (let _68_10352 = (Support.List.nth args' 0)
in (Support.Prims.pipe_right _68_10352 arg_to_string))
in (let _68_10355 = (Support.Prims.pipe_right e infix_prim_op_to_string)
in (let _68_10354 = (let _68_10353 = (Support.List.nth args' 1)
in (Support.Prims.pipe_right _68_10353 arg_to_string))
in (Support.Microsoft.FStar.Util.format3 "(%s %s %s)" _68_10356 _68_10355 _68_10354))))
end
| false -> begin
(match (((is_unary_prim_op e) && ((Support.List.length args') = 1))) with
| true -> begin
(let _68_10359 = (Support.Prims.pipe_right e unary_prim_op_to_string)
in (let _68_10358 = (let _68_10357 = (Support.List.nth args' 0)
in (Support.Prims.pipe_right _68_10357 arg_to_string))
in (Support.Microsoft.FStar.Util.format2 "(%s %s)" _68_10359 _68_10358)))
end
| false -> begin
(let _68_10361 = (Support.Prims.pipe_right e exp_to_string)
in (let _68_10360 = (args_to_string args)
in (Support.Microsoft.FStar.Util.format2 "(%s %s)" _68_10361 _68_10360)))
end)
end))
end))
end
| Microsoft_FStar_Absyn_Syntax.Exp_match ((e, pats)) -> begin
(let _68_10369 = (Support.Prims.pipe_right e exp_to_string)
in (let _68_10368 = (let _68_10367 = (Support.Prims.pipe_right pats (Support.List.map (fun ( _24_588 ) -> (match (_24_588) with
| (p, wopt, e) -> begin
(let _68_10366 = (Support.Prims.pipe_right p pat_to_string)
in (let _68_10365 = (match (wopt) with
| None -> begin
""
end
| Some (w) -> begin
(let _68_10363 = (Support.Prims.pipe_right w exp_to_string)
in (Support.Microsoft.FStar.Util.format1 "when %s" _68_10363))
end)
in (let _68_10364 = (Support.Prims.pipe_right e exp_to_string)
in (Support.Microsoft.FStar.Util.format3 "%s %s -> %s" _68_10366 _68_10365 _68_10364))))
end))))
in (Support.Microsoft.FStar.Util.concat_l "\n\t" _68_10367))
in (Support.Microsoft.FStar.Util.format2 "(match %s with %s)" _68_10369 _68_10368)))
end
| Microsoft_FStar_Absyn_Syntax.Exp_ascribed ((e, t, _)) -> begin
(let _68_10371 = (Support.Prims.pipe_right e exp_to_string)
in (let _68_10370 = (Support.Prims.pipe_right t typ_to_string)
in (Support.Microsoft.FStar.Util.format2 "(%s:%s)" _68_10371 _68_10370)))
end
| Microsoft_FStar_Absyn_Syntax.Exp_let ((lbs, e)) -> begin
(let _68_10373 = (lbs_to_string lbs)
in (let _68_10372 = (Support.Prims.pipe_right e exp_to_string)
in (Support.Microsoft.FStar.Util.format2 "%s in %s" _68_10373 _68_10372)))
end))
and uvar_e_to_string = (fun ( _24_605 ) -> (match (_24_605) with
| (uv, _) -> begin
(let _68_10376 = (match ((Support.ST.read Microsoft_FStar_Options.hide_uvar_nums)) with
| true -> begin
"?"
end
| false -> begin
(let _68_10375 = (Support.Microsoft.FStar.Unionfind.uvar_id uv)
in (Support.Microsoft.FStar.Util.string_of_int _68_10375))
end)
in (Support.String.strcat "\'e" _68_10376))
end))
and lbs_to_string = (fun ( lbs ) -> (let _68_10383 = (let _68_10382 = (Support.Prims.pipe_right (Support.Prims.snd lbs) (Support.List.map (fun ( lb ) -> (let _68_10381 = (lbname_to_string lb.Microsoft_FStar_Absyn_Syntax.lbname)
in (let _68_10380 = (Support.Prims.pipe_right lb.Microsoft_FStar_Absyn_Syntax.lbtyp typ_to_string)
in (let _68_10379 = (Support.Prims.pipe_right lb.Microsoft_FStar_Absyn_Syntax.lbdef exp_to_string)
in (Support.Microsoft.FStar.Util.format3 "%s:%s = %s" _68_10381 _68_10380 _68_10379)))))))
in (Support.Microsoft.FStar.Util.concat_l "\n and " _68_10382))
in (Support.Microsoft.FStar.Util.format2 "let %s %s" (match ((Support.Prims.fst lbs)) with
| true -> begin
"rec"
end
| false -> begin
""
end) _68_10383)))
and lbname_to_string = (fun ( x ) -> (match (x) with
| Support.Microsoft.FStar.Util.Inl (bvd) -> begin
(strBvd bvd)
end
| Support.Microsoft.FStar.Util.Inr (lid) -> begin
(sli lid)
end))
and either_to_string = (fun ( x ) -> (match (x) with
| Support.Microsoft.FStar.Util.Inl (t) -> begin
(typ_to_string t)
end
| Support.Microsoft.FStar.Util.Inr (e) -> begin
(exp_to_string e)
end))
and either_l_to_string = (fun ( delim ) ( l ) -> (let _68_10388 = (Support.Prims.pipe_right l (Support.List.map either_to_string))
in (Support.Prims.pipe_right _68_10388 (Support.Microsoft.FStar.Util.concat_l delim))))
and meta_to_string = (fun ( x ) -> (match (x) with
| Microsoft_FStar_Absyn_Syntax.Meta_refresh_label ((t, _, _)) -> begin
(let _68_10390 = (typ_to_string t)
in (Support.Microsoft.FStar.Util.format1 "(refresh) %s" _68_10390))
end
| Microsoft_FStar_Absyn_Syntax.Meta_labeled ((t, l, _, _)) -> begin
(let _68_10391 = (typ_to_string t)
in (Support.Microsoft.FStar.Util.format2 "(labeled \"%s\") %s" l _68_10391))
end
| Microsoft_FStar_Absyn_Syntax.Meta_named ((_, l)) -> begin
(sli l)
end
| Microsoft_FStar_Absyn_Syntax.Meta_pattern ((t, ps)) -> begin
(let _68_10393 = (args_to_string ps)
in (let _68_10392 = (Support.Prims.pipe_right t typ_to_string)
in (Support.Microsoft.FStar.Util.format2 "{:pattern %s} %s" _68_10393 _68_10392)))
end
| Microsoft_FStar_Absyn_Syntax.Meta_slack_formula ((t1, t2, _)) -> begin
(let _68_10395 = (formula_to_string t1)
in (let _68_10394 = (formula_to_string t2)
in (Support.Microsoft.FStar.Util.format2 "%s /\\ %s" _68_10395 _68_10394)))
end))
and kind_to_string = (fun ( x ) -> (match ((let _68_10397 = (Microsoft_FStar_Absyn_Util.compress_kind x)
in _68_10397.Microsoft_FStar_Absyn_Syntax.n)) with
| Microsoft_FStar_Absyn_Syntax.Kind_lam (_) -> begin
(failwith ("Impossible"))
end
| Microsoft_FStar_Absyn_Syntax.Kind_delayed (_) -> begin
(failwith ("Impossible"))
end
| Microsoft_FStar_Absyn_Syntax.Kind_uvar ((uv, args)) -> begin
(uvar_k_to_string' (uv, args))
end
| Microsoft_FStar_Absyn_Syntax.Kind_type -> begin
"Type"
end
| Microsoft_FStar_Absyn_Syntax.Kind_effect -> begin
"Effect"
end
| Microsoft_FStar_Absyn_Syntax.Kind_abbrev (((n, args), k)) -> begin
(match ((Support.ST.read Microsoft_FStar_Options.print_real_names)) with
| true -> begin
(kind_to_string k)
end
| false -> begin
(let _68_10399 = (sli n)
in (let _68_10398 = (args_to_string args)
in (Support.Microsoft.FStar.Util.format2 "%s %s" _68_10399 _68_10398)))
end)
end
| Microsoft_FStar_Absyn_Syntax.Kind_arrow ((binders, k)) -> begin
(let _68_10401 = (binders_to_string " -> " binders)
in (let _68_10400 = (Support.Prims.pipe_right k kind_to_string)
in (Support.Microsoft.FStar.Util.format2 "(%s -> %s)" _68_10401 _68_10400)))
end
| Microsoft_FStar_Absyn_Syntax.Kind_unknown -> begin
"_"
end))
and uvar_k_to_string = (fun ( uv ) -> (let _68_10403 = (match ((Support.ST.read Microsoft_FStar_Options.hide_uvar_nums)) with
| true -> begin
"?"
end
| false -> begin
(let _68_10402 = (Support.Microsoft.FStar.Unionfind.uvar_id uv)
in (Support.Microsoft.FStar.Util.string_of_int _68_10402))
end)
in (Support.String.strcat "\'k_" _68_10403)))
and uvar_k_to_string' = (fun ( _24_678 ) -> (match (_24_678) with
| (uv, args) -> begin
(let str = (match ((Support.ST.read Microsoft_FStar_Options.hide_uvar_nums)) with
| true -> begin
"?"
end
| false -> begin
(let _68_10405 = (Support.Microsoft.FStar.Unionfind.uvar_id uv)
in (Support.Microsoft.FStar.Util.string_of_int _68_10405))
end)
in (let _68_10406 = (args_to_string args)
in (Support.Microsoft.FStar.Util.format2 "(\'k_%s %s)" str _68_10406)))
end))
and pat_to_string = (fun ( x ) -> (match (x.Microsoft_FStar_Absyn_Syntax.v) with
| Microsoft_FStar_Absyn_Syntax.Pat_cons ((l, _, pats)) -> begin
(let _68_10410 = (sli l.Microsoft_FStar_Absyn_Syntax.v)
in (let _68_10409 = (let _68_10408 = (Support.List.map pat_to_string pats)
in (Support.Prims.pipe_right _68_10408 (Support.String.concat " ")))
in (Support.Microsoft.FStar.Util.format2 "(%s %s)" _68_10410 _68_10409)))
end
| Microsoft_FStar_Absyn_Syntax.Pat_dot_term ((x, _)) -> begin
(let _68_10411 = (strBvd x.Microsoft_FStar_Absyn_Syntax.v)
in (Support.Microsoft.FStar.Util.format1 ".%s" _68_10411))
end
| Microsoft_FStar_Absyn_Syntax.Pat_dot_typ ((x, _)) -> begin
(let _68_10412 = (strBvd x.Microsoft_FStar_Absyn_Syntax.v)
in (Support.Microsoft.FStar.Util.format1 ".\'%s" _68_10412))
end
| Microsoft_FStar_Absyn_Syntax.Pat_var ((x, true)) -> begin
(let _68_10413 = (strBvd x.Microsoft_FStar_Absyn_Syntax.v)
in (Support.Microsoft.FStar.Util.format1 "#%s" _68_10413))
end
| Microsoft_FStar_Absyn_Syntax.Pat_var ((x, false)) -> begin
(strBvd x.Microsoft_FStar_Absyn_Syntax.v)
end
| Microsoft_FStar_Absyn_Syntax.Pat_tvar (a) -> begin
(strBvd a.Microsoft_FStar_Absyn_Syntax.v)
end
| Microsoft_FStar_Absyn_Syntax.Pat_constant (c) -> begin
(const_to_string c)
end
| Microsoft_FStar_Absyn_Syntax.Pat_wild (_) -> begin
"_"
end
| Microsoft_FStar_Absyn_Syntax.Pat_twild (_) -> begin
"\'_"
end
| Microsoft_FStar_Absyn_Syntax.Pat_disj (ps) -> begin
(let _68_10414 = (Support.List.map pat_to_string ps)
in (Support.Microsoft.FStar.Util.concat_l " | " _68_10414))
end))

let subst_to_string = (fun ( subst ) -> (let _68_10422 = (let _68_10421 = (Support.List.map (fun ( _24_17 ) -> (match (_24_17) with
| Support.Microsoft.FStar.Util.Inl ((a, t)) -> begin
(let _68_10418 = (strBvd a)
in (let _68_10417 = (typ_to_string t)
in (Support.Microsoft.FStar.Util.format2 "(%s -> %s)" _68_10418 _68_10417)))
end
| Support.Microsoft.FStar.Util.Inr ((x, e)) -> begin
(let _68_10420 = (strBvd x)
in (let _68_10419 = (exp_to_string e)
in (Support.Microsoft.FStar.Util.format2 "(%s -> %s)" _68_10420 _68_10419)))
end)) subst)
in (Support.Prims.pipe_right _68_10421 (Support.String.concat ", ")))
in (Support.Prims.pipe_left (Support.Microsoft.FStar.Util.format1 "{%s}") _68_10422)))

let freevars_to_string = (fun ( fvs ) -> (let f = (fun ( l ) -> (let _68_10428 = (let _68_10427 = (Support.Prims.pipe_right l Support.Microsoft.FStar.Util.set_elements)
in (Support.Prims.pipe_right _68_10427 (Support.List.map (fun ( t ) -> (strBvd t.Microsoft_FStar_Absyn_Syntax.v)))))
in (Support.Prims.pipe_right _68_10428 (Support.String.concat ", "))))
in (let _68_10430 = (f fvs.Microsoft_FStar_Absyn_Syntax.ftvs)
in (let _68_10429 = (f fvs.Microsoft_FStar_Absyn_Syntax.fxvs)
in (Support.Microsoft.FStar.Util.format2 "ftvs={%s}, fxvs={%s}" _68_10430 _68_10429)))))

let qual_to_string = (fun ( _24_18 ) -> (match (_24_18) with
| Microsoft_FStar_Absyn_Syntax.Logic -> begin
"logic"
end
| Microsoft_FStar_Absyn_Syntax.Opaque -> begin
"opaque"
end
| Microsoft_FStar_Absyn_Syntax.Discriminator (_) -> begin
"discriminator"
end
| Microsoft_FStar_Absyn_Syntax.Projector (_) -> begin
"projector"
end
| Microsoft_FStar_Absyn_Syntax.RecordType (ids) -> begin
(let _68_10435 = (let _68_10434 = (Support.Prims.pipe_right ids (Support.List.map (fun ( lid ) -> lid.Microsoft_FStar_Absyn_Syntax.ident.Microsoft_FStar_Absyn_Syntax.idText)))
in (Support.Prims.pipe_right _68_10434 (Support.String.concat ", ")))
in (Support.Microsoft.FStar.Util.format1 "record(%s)" _68_10435))
end
| _ -> begin
"other"
end))

let quals_to_string = (fun ( quals ) -> (let _68_10438 = (Support.Prims.pipe_right quals (Support.List.map qual_to_string))
in (Support.Prims.pipe_right _68_10438 (Support.String.concat " "))))

let rec sigelt_to_string = (fun ( x ) -> (match (x) with
| Microsoft_FStar_Absyn_Syntax.Sig_pragma ((Microsoft_FStar_Absyn_Syntax.ResetOptions, _)) -> begin
"#reset-options"
end
| Microsoft_FStar_Absyn_Syntax.Sig_pragma ((Microsoft_FStar_Absyn_Syntax.SetOptions (s), _)) -> begin
(Support.Microsoft.FStar.Util.format1 "#set-options \"%s\"" s)
end
| Microsoft_FStar_Absyn_Syntax.Sig_tycon ((lid, tps, k, _, _, quals, _)) -> begin
(let _68_10443 = (quals_to_string quals)
in (let _68_10442 = (binders_to_string " " tps)
in (let _68_10441 = (kind_to_string k)
in (Support.Microsoft.FStar.Util.format4 "%s type %s %s : %s" _68_10443 lid.Microsoft_FStar_Absyn_Syntax.str _68_10442 _68_10441))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_typ_abbrev ((lid, tps, k, t, _, _)) -> begin
(let _68_10446 = (binders_to_string " " tps)
in (let _68_10445 = (kind_to_string k)
in (let _68_10444 = (typ_to_string t)
in (Support.Microsoft.FStar.Util.format4 "type %s %s : %s = %s" lid.Microsoft_FStar_Absyn_Syntax.str _68_10446 _68_10445 _68_10444))))
end
| Microsoft_FStar_Absyn_Syntax.Sig_datacon ((lid, t, _, _, _, _)) -> begin
(let _68_10447 = (typ_to_string t)
in (Support.Microsoft.FStar.Util.format2 "datacon %s : %s" lid.Microsoft_FStar_Absyn_Syntax.str _68_10447))
end
| Microsoft_FStar_Absyn_Syntax.Sig_val_decl ((lid, t, quals, _)) -> begin
(let _68_10449 = (quals_to_string quals)
in (let _68_10448 = (typ_to_string t)
in (Support.Microsoft.FStar.Util.format3 "%s val %s : %s" _68_10449 lid.Microsoft_FStar_Absyn_Syntax.str _68_10448)))
end
| Microsoft_FStar_Absyn_Syntax.Sig_assume ((lid, f, _, _)) -> begin
(let _68_10450 = (typ_to_string f)
in (Support.Microsoft.FStar.Util.format2 "val %s : %s" lid.Microsoft_FStar_Absyn_Syntax.str _68_10450))
end
| Microsoft_FStar_Absyn_Syntax.Sig_let ((lbs, _, _, b)) -> begin
(lbs_to_string lbs)
end
| Microsoft_FStar_Absyn_Syntax.Sig_main ((e, _)) -> begin
(let _68_10451 = (exp_to_string e)
in (Support.Microsoft.FStar.Util.format1 "let _ = %s" _68_10451))
end
| Microsoft_FStar_Absyn_Syntax.Sig_bundle ((ses, _, _, _)) -> begin
(let _68_10452 = (Support.List.map sigelt_to_string ses)
in (Support.Prims.pipe_right _68_10452 (Support.String.concat "\n")))
end
| Microsoft_FStar_Absyn_Syntax.Sig_new_effect (_) -> begin
"new_effect { ... }"
end
| Microsoft_FStar_Absyn_Syntax.Sig_sub_effect (_) -> begin
"sub_effect ..."
end
| Microsoft_FStar_Absyn_Syntax.Sig_kind_abbrev (_) -> begin
"kind ..."
end
| Microsoft_FStar_Absyn_Syntax.Sig_effect_abbrev ((l, tps, c, _, _)) -> begin
(let _68_10455 = (sli l)
in (let _68_10454 = (binders_to_string " " tps)
in (let _68_10453 = (comp_typ_to_string c)
in (Support.Microsoft.FStar.Util.format3 "effect %s %s = %s" _68_10455 _68_10454 _68_10453))))
end))

let format_error = (fun ( r ) ( msg ) -> (let _68_10460 = (Support.Microsoft.FStar.Range.string_of_range r)
in (Support.Microsoft.FStar.Util.format2 "%s: %s\n" _68_10460 msg)))

let rec sigelt_to_string_short = (fun ( x ) -> (match (x) with
| Microsoft_FStar_Absyn_Syntax.Sig_let (((_, {Microsoft_FStar_Absyn_Syntax.lbname = Support.Microsoft.FStar.Util.Inr (l); Microsoft_FStar_Absyn_Syntax.lbtyp = t; Microsoft_FStar_Absyn_Syntax.lbeff = _; Microsoft_FStar_Absyn_Syntax.lbdef = _}::[]), _, _, _)) -> begin
(let _68_10463 = (typ_to_string t)
in (Support.Microsoft.FStar.Util.format2 "let %s : %s" l.Microsoft_FStar_Absyn_Syntax.str _68_10463))
end
| _ -> begin
(let _68_10466 = (let _68_10465 = (Microsoft_FStar_Absyn_Util.lids_of_sigelt x)
in (Support.Prims.pipe_right _68_10465 (Support.List.map (fun ( l ) -> l.Microsoft_FStar_Absyn_Syntax.str))))
in (Support.Prims.pipe_right _68_10466 (Support.String.concat ", ")))
end))

let rec modul_to_string = (fun ( m ) -> (let _68_10471 = (sli m.Microsoft_FStar_Absyn_Syntax.name)
in (let _68_10470 = (let _68_10469 = (Support.List.map sigelt_to_string m.Microsoft_FStar_Absyn_Syntax.declarations)
in (Support.Prims.pipe_right _68_10469 (Support.String.concat "\n")))
in (Support.Microsoft.FStar.Util.format2 "module %s\n%s" _68_10471 _68_10470))))




