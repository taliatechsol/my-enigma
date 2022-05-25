import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { users } from 'src/interfaces/user.interface';
import { user, userDocument } from 'src/schemas/user.schema';
import * as bcrypt from "bcrypt";

import { randomInt } from 'crypto';

@Injectable()
export class UserService {
  constructor(
    @InjectModel('users') private readonly userModel: Model<userDocument>,
  ) {}

  async validateUser(user : users): Promise<boolean> {
    try{
      const usrCount = await this.userModel.countDocuments({mobileNumber : user.mobileNumber});
      if(usrCount <= 0) {
        return true;
      } else {
        return false;
      }
    } catch(err) {
      return err;
    }
  }

  async validateUserByID (user : users): Promise<boolean> {
    try{
      const usrCount = await this.userModel.countDocuments({_id : user._id});
      if(usrCount == 1) {
        return true;
      } else {
        return false;
      }
    } catch(err) {
      return err
    }
  }

  async createUser(user: users): Promise<user> {
    try {
      const createUser = new this.userModel(user);
      return createUser.save();
    } catch (err) {
      return err;
    }
  }

  async updatePassword(user : users) : Promise<boolean> {
    try{
      const passwordHash = await bcrypt.hash(user.password,await bcrypt.genSalt());
      const update = await this.userModel.findByIdAndUpdate(user._id,{"password" : passwordHash});
      if(update._id != null || update._id != undefined) {
        return true;
      } else {
        return false;
      }
    } catch(err) {
      return false;
    }
  }

  async generateOTP(user: users): Promise<number> {
    try {
      const otp = randomInt(1000, 9999);
      const updateUser = await this.userModel.updateOne(
        { _id: user._id },
        { $set: { otp: otp } },
      );
      const findUser = await this.userModel.findById({ _id: user._id }).projection({"otp" : 1}).exec();
      return findUser;
    } catch (err) {
      return err;
    }
  }

  async validateOTP(user: users): Promise<boolean> {
    try {
      const findUser = await this.userModel
        .findOne({ _id: user._id, otp: user.otp })
        .countDocuments()
        .exec();
      if(findUser > 0) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      return err;
    }
  }

  // async jwtGenerate (user : users) : Promise <user> {
  //     try {
  //         const finduser = await this.userModel.findById({_id : user._id}).exec();

  //     } catch (err) {
  //         return err
  //     }
  // }
}
