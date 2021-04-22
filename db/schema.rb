# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180223222213) do

  create_table "branches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "chain_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chain_id"], name: "index_branches_on_chain_id", using: :btree
  end

  create_table "chains", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mapcomponents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float    "X",           limit: 24
    t.float    "Y",           limit: 24
    t.integer  "is_vertical"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "mapnodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float    "X",          limit: 24
    t.float    "Y",          limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "mapregions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float    "x",          limit: 24
    t.float    "y",          limit: 24
    t.float    "width",      limit: 24
    t.float    "height",     limit: 24
    t.float    "r",          limit: 24
    t.float    "g",          limit: 24
    t.float    "b",          limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "name"
  end

  create_table "nodenodeweights", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "node1_id_id"
    t.integer  "node2_id_id"
    t.float    "distance",    limit: 24
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["node1_id_id"], name: "index_nodenodeweights_on_node1_id_id", using: :btree
    t.index ["node2_id_id"], name: "index_nodenodeweights_on_node2_id_id", using: :btree
  end

  create_table "product_nodes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "product_id"
    t.integer  "mapnode_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mapnode_id"], name: "index_product_nodes_on_mapnode_id", using: :btree
    t.index ["product_id"], name: "index_product_nodes_on_product_id", using: :btree
  end

  create_table "productlocations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "product_id"
    t.float    "X",          limit: 24
    t.float    "Y",          limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["product_id"], name: "index_productlocations_on_product_id", using: :btree
  end

  create_table "products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shoppinglists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "chain_id"
    t.integer  "branch_id"
    t.date     "date"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_shoppinglists_on_branch_id", using: :btree
    t.index ["chain_id"], name: "index_shoppinglists_on_chain_id", using: :btree
    t.index ["user_id"], name: "index_shoppinglists_on_user_id", using: :btree
  end

  create_table "shoppinglistsitem", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "shoppinglist_id"
    t.integer  "product_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["product_id"], name: "index_shoppinglistsitem_on_product_id", using: :btree
    t.index ["shoppinglist_id"], name: "index_shoppinglistsitem_on_shoppinglist_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "user_name"
    t.string   "user_gender"
    t.string   "user_email"
    t.string   "user_password"
    t.string   "user_dob"
    t.string   "user_phone"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_foreign_key "branches", "chains", on_delete: :cascade
  add_foreign_key "nodenodeweights", "mapnodes", column: "node1_id_id"
  add_foreign_key "nodenodeweights", "mapnodes", column: "node2_id_id"
  add_foreign_key "product_nodes", "mapnodes", on_delete: :cascade
  add_foreign_key "product_nodes", "products", on_delete: :cascade
  add_foreign_key "productlocations", "products", on_delete: :cascade
  add_foreign_key "shoppinglists", "branches", on_delete: :cascade
  add_foreign_key "shoppinglists", "chains", on_delete: :cascade
  add_foreign_key "shoppinglists", "users", on_delete: :cascade
  add_foreign_key "shoppinglistsitem", "products", on_delete: :cascade
  add_foreign_key "shoppinglistsitem", "shoppinglists", on_delete: :cascade
end
